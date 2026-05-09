import json
import os
from datetime import datetime, timezone

import boto3

from scoring import calculate_risk_score, recommended_action
from severity_classifier import classify_severity
from control_mapper import map_controls

s3_client = boto3.client("s3")
bedrock_client = boto3.client("bedrock-runtime")

EVIDENCE_STORE_BUCKET = os.environ["EVIDENCE_STORE_BUCKET"]
BEDROCK_MODEL_ID = os.environ.get("BEDROCK_MODEL_ID")


def build_business_impact(finding_type: str, severity: str, risk_score: int) -> str:
    if finding_type == "privilege_escalation":
        return (
            f"A {severity} privilege escalation finding with a risk score of {risk_score} "
            "may allow unauthorized access to sensitive cloud resources or administrative actions."
        )

    if finding_type == "credential_exfiltration":
        return (
            f"A {severity} credential exfiltration finding with a risk score of {risk_score} "
            "may indicate compromised credentials that could be used for lateral movement or data access."
        )

    if finding_type == "public_exposure":
        return (
            f"A {severity} public exposure finding with a risk score of {risk_score} "
            "may expose sensitive systems or data to unauthorized external access."
        )

    if finding_type == "crypto_mining":
        return (
            f"A {severity} crypto mining finding with a risk score of {risk_score} "
            "may indicate resource abuse, increased cloud spend, or compromised compute resources."
        )

    if finding_type == "data_exfiltration":
        return (
            f"A {severity} data exfiltration finding with a risk score of {risk_score} "
            "may indicate unauthorized movement of sensitive data outside approved trust boundaries."
        )

    if finding_type == "iam_anomaly":
        return (
            f"A {severity} IAM anomaly finding with a risk score of {risk_score} "
            "may indicate unusual identity behavior requiring access review and session validation."
        )

    if finding_type == "disabled_guardrails":
        return (
            f"A {severity} disabled guardrails finding with a risk score of {risk_score} "
            "may indicate weakened preventive controls or intentional bypass of security enforcement."
        )

    return (
        f"A {severity} security finding with a risk score of {risk_score} "
        "requires review to determine business impact and remediation priority."
    )


def generate_ai_enrichment(risk_result: dict) -> dict:
    """
    Bedrock is used only as an enrichment layer.
    Deterministic scoring, severity classification, and compliance mapping remain authoritative.
    """
    if not BEDROCK_MODEL_ID:
        return {
            "ai_enrichment_status": "disabled",
            "executive_summary": "Bedrock model ID was not configured.",
            "analyst_summary": "AI enrichment was skipped because BEDROCK_MODEL_ID is missing.",
            "ai_recommended_next_steps": [],
            "ai_compliance_impact": "Not evaluated by AI.",
        }

    prompt = f"""
You are assisting a cloud security analyst reviewing an AWS security finding.

Use the provided finding only. Do not invent facts. Keep the response concise.

Return valid JSON only with these keys:
- executive_summary
- analyst_summary
- recommended_next_steps
- compliance_impact

Finding:
{json.dumps(risk_result, indent=2)}
""".strip()

    try:
        response = bedrock_client.converse(
            modelId=BEDROCK_MODEL_ID,
            messages=[
                {
                    "role": "user",
                    "content": [{"text": prompt}],
                }
            ],
            inferenceConfig={
                "maxTokens": 500,
                "temperature": 0.2,
            },
        )

        ai_text = response["output"]["message"]["content"][0]["text"]

        try:
            parsed_ai = json.loads(ai_text)
        except json.JSONDecodeError:
            parsed_ai = {
                "executive_summary": ai_text,
                "analyst_summary": ai_text,
                "recommended_next_steps": [],
                "compliance_impact": "AI response was not valid JSON.",
            }

        return {
            "ai_enrichment_status": "success",
            "executive_summary": parsed_ai.get("executive_summary", ""),
            "analyst_summary": parsed_ai.get("analyst_summary", ""),
            "ai_recommended_next_steps": parsed_ai.get("recommended_next_steps", []),
            "ai_compliance_impact": parsed_ai.get("compliance_impact", ""),
            "bedrock_model_id": BEDROCK_MODEL_ID,
        }

    except Exception as error:
        print(f"Bedrock enrichment failed: {str(error)}")
        return {
            "ai_enrichment_status": "failed",
            "executive_summary": "AI enrichment failed.",
            "analyst_summary": str(error),
            "ai_recommended_next_steps": [],
            "ai_compliance_impact": "AI enrichment failed.",
            "bedrock_model_id": BEDROCK_MODEL_ID,
        }


def lambda_handler(event, context):
    print("Incoming normalized event:", json.dumps(event))

    detail = event.get("detail", {})
    finding_type = detail.get("finding_type", "unknown").lower()

    risk_score = calculate_risk_score(detail)
    risk_classification = classify_severity(risk_score)
    action = recommended_action(risk_score)
    control_mappings = map_controls(finding_type)
    business_impact = build_business_impact(
        finding_type=finding_type,
        severity=risk_classification,
        risk_score=risk_score,
    )

    processed_at = datetime.now(timezone.utc).isoformat()

    risk_result = {
        "event_id": event.get("event_id", "unknown"),
        "source": event.get("source", "unknown"),
        "detail_type": event.get("detail_type", "unknown"),
        "account": event.get("account", "unknown"),
        "region": event.get("region", "unknown"),
        "event_time": event.get("time"),
        "finding_type": finding_type,
        "original_severity": detail.get("severity", "unknown"),
        "risk_score": risk_score,
        "risk_classification": risk_classification,
        "business_impact": business_impact,
        "recommended_action": action,
        "control_mappings": control_mappings,
        "pipeline_stage": "risk_scored",
        "processed_at": processed_at,
        "original_event": event,
    }

    ai_enrichment = generate_ai_enrichment(risk_result)
    risk_result.update(ai_enrichment)

    s3_key = (
        "risk-results/"
        f"year={processed_at[0:4]}/"
        f"month={processed_at[5:7]}/"
        f"day={processed_at[8:10]}/"
        f"{risk_result['event_id']}.json"
    )

    s3_client.put_object(
        Bucket=EVIDENCE_STORE_BUCKET,
        Key=s3_key,
        Body=json.dumps(risk_result, indent=2).encode("utf-8"),
        ContentType="application/json",
    )

    print("Risk result:", json.dumps(risk_result))
    print(f"Evidence written to s3://{EVIDENCE_STORE_BUCKET}/{s3_key}")

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "Risk result written to evidence store",
                "bucket": EVIDENCE_STORE_BUCKET,
                "key": s3_key,
                "risk_score": risk_score,
                "risk_classification": risk_classification,
                "recommended_action": action,
                "control_mappings": control_mappings,
                "ai_enrichment_status": risk_result.get("ai_enrichment_status"),
                "executive_summary": risk_result.get("executive_summary"),
            }
        ),
    }