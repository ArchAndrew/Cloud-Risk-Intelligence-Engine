import json
import os
import urllib.request
import urllib.error
import boto3
from urllib.parse import unquote_plus

s3_client = boto3.client("s3")

SPLUNK_HEC_URL = os.environ["SPLUNK_HEC_URL"]
SPLUNK_HEC_TOKEN = os.environ["SPLUNK_HEC_TOKEN"]
SPLUNK_INDEX = os.environ.get("SPLUNK_INDEX", "machine_lite")
SPLUNK_SOURCETYPE = os.environ.get("SPLUNK_SOURCETYPE", "aws:machine_lite:risk")


def send_to_splunk(event_payload: dict) -> None:
    splunk_event = {
        "index": SPLUNK_INDEX,
        "sourcetype": SPLUNK_SOURCETYPE,
        "event": event_payload,
    }

    request = urllib.request.Request(
        SPLUNK_HEC_URL,
        data=json.dumps(splunk_event).encode("utf-8"),
        headers={
            "Authorization": f"Splunk {SPLUNK_HEC_TOKEN}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=10) as response:
            print("Splunk response:", response.status, response.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        print("Splunk HTTP error:", e.code, e.read().decode("utf-8"))
        raise
    except urllib.error.URLError as e:
        print("Splunk URL error:", str(e))
        raise


def lambda_handler(event, context):
    print("Received S3 event:", json.dumps(event))

    for record in event.get("Records", []):
        bucket = record["s3"]["bucket"]["name"]
        key = unquote_plus(record["s3"]["object"]["key"])

        response = s3_client.get_object(Bucket=bucket, Key=key)
        body = response["Body"].read().decode("utf-8")
        risk_result = json.loads(body)

        print("Forwarding risk result to Splunk:", json.dumps(risk_result))
        send_to_splunk(risk_result)

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Risk results forwarded to Splunk"})
    }