import json
import os
import boto3

from approval_rules import requires_human_approval, build_approval_message

sns = boto3.client("sns")

APPROVAL_TOPIC_ARN = os.environ.get("APPROVAL_TOPIC_ARN")


def lambda_handler(event, context):
    print("Received approval event:", json.dumps(event))

    risk_result = event.get("risk_result", event)

    if not requires_human_approval(risk_result):
        return {
            "statusCode": 200,
            "body": json.dumps({
                "approval_required": False,
                "message": "Risk result does not require human approval."
            })
        }

    if not APPROVAL_TOPIC_ARN:
        raise ValueError("APPROVAL_TOPIC_ARN environment variable is not set.")

    message = build_approval_message(risk_result)

    response = sns.publish(
        TopicArn=APPROVAL_TOPIC_ARN,
        Subject="Machine-Lite Approval Required",
        Message=message,
    )

    return {
        "statusCode": 200,
        "body": json.dumps({
            "approval_required": True,
            "sns_message_id": response.get("MessageId")
        })
    }