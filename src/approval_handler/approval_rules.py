def requires_human_approval(risk_result: dict) -> bool:
    risk_score = int(risk_result.get("risk_score", 0))
    severity = str(risk_result.get("risk_classification", "")).lower()
    finding_type = str(risk_result.get("finding_type", "")).lower()

    high_risk_types = {
        "privilege_escalation",
        "data_exfiltration",
        "public_exposure",
        "root_account_activity",
        "disabled_guardrails",
    }

    return (
        risk_score >= 90
        or severity == "critical"
        or finding_type in high_risk_types
    )


def build_approval_message(risk_result: dict) -> str:
    return f"""
Machine-Lite Human Approval Required

Finding Type: {risk_result.get("finding_type", "unknown")}
Risk Score: {risk_result.get("risk_score", "unknown")}
Severity: {risk_result.get("risk_classification", "unknown")}
Region: {risk_result.get("region", "unknown")}

Business Impact:
{risk_result.get("business_impact", "No business impact provided.")}

Recommended Action:
{risk_result.get("recommended_action", "No recommendation provided.")}

Approval Decision Required:
Review before containment, escalation, or remediation workflow proceeds.
""".strip()