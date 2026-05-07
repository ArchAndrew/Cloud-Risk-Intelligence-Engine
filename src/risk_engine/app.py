import json
import os
import boto3
from datetime import datetime, timezone

from scoring import calculate_risk_score, recommended_action
from severity_classifier import classify_severity
from control_mapper import map_controls

s3_client = boto3.client("s3")

EVIDENCE_STORE_BUCKET = os.environ["EVIDENCE_STORE_BUCKET"]


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

    return (
        f"A {severity} security finding with a risk score of {risk_score} "
        "requires review to determine business impact and remediation priority."
    )


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

    s3_key = (
        f"risk-results/"
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
        "body": json.dumps({
            "message": "Risk result written to evidence store",
            "bucket": EVIDENCE_STORE_BUCKET,
            "key": s3_key,
            "risk_score": risk_score,
            "risk_classification": risk_classification,
            "recommended_action": action,
            "control_mappings": control_mappings,
        }),
    }