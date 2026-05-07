import json
import os
import boto3

from event_parser import parse_security_event

s3_client = boto3.client("s3")
lambda_client = boto3.client("lambda")

EVIDENCE_BUCKET = os.environ["EVIDENCE_BUCKET"]
RISK_ENGINE_FUNCTION_NAME = os.environ["RISK_ENGINE_FUNCTION_NAME"]


def write_evidence_to_s3(normalized_event: dict) -> str:
    event_id = normalized_event.get("event_id", "unknown")
    event_time = normalized_event.get("event_time", "unknown")

    # Creates a predictable evidence path for later audit/review.
    object_key = f"normalized-events/{event_time}/{event_id}.json"

    s3_client.put_object(
        Bucket=EVIDENCE_BUCKET,
        Key=object_key,
        Body=json.dumps(normalized_event, indent=2).encode("utf-8"),
        ContentType="application/json",
    )

    return object_key


def invoke_risk_engine(normalized_event: dict, evidence_key: str) -> None:
    payload = {
        "normalized_event": normalized_event,
        "evidence_bucket": EVIDENCE_BUCKET,
        "evidence_key": evidence_key,
    }

    lambda_client.invoke(
        FunctionName=RISK_ENGINE_FUNCTION_NAME,
        InvocationType="Event",
        Payload=json.dumps(payload).encode("utf-8"),
    )


def lambda_handler(event, context):
    print("Received raw event:", json.dumps(event))

    normalized_event = parse_security_event(event)

    print("Normalized event:", json.dumps(normalized_event))

    evidence_key = write_evidence_to_s3(normalized_event)

    print(f"Evidence written to s3://{EVIDENCE_BUCKET}/{evidence_key}")

    invoke_risk_engine(normalized_event, evidence_key)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Event normalized and forwarded to risk engine",
            "evidence_bucket": EVIDENCE_BUCKET,
            "evidence_key": evidence_key,
        }),
    }