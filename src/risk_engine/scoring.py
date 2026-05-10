# Calculates risk score based on severity, finding type, exposure, and identity impact.


def calculate_risk_score(detail: dict) -> int:
    """
    Calculates a risk score from 0-100 based on severity, finding type,
    exposure, and identity impact.
    """
    score = 30

    severity = str(detail.get("severity", "medium")).lower()
    finding_type = str(detail.get("finding_type", "unknown")).lower()
    exposure = str(detail.get("exposure", "internal")).lower()
    identity_impact = str(detail.get("identity_impact", "standard")).lower()

    severity_weights = {
        "critical": 30,
        "high": 20,
        "medium": 10,
        "low": 0,
        "unknown": 0,
    }

    finding_type_weights = {
        "privilege_escalation": 25,
        "credential_exfiltration": 30,
        "data_exfiltration": 30,
        "public_exposure": 20,
        "malware": 25,
        "crypto_mining": 20,
        "brute_force": 15,
        "unusual_region_activity": 15,
        "iam_anomaly": 20,
        "disabled_guardrails": 25,
        "unknown": 0,
    }

    exposure_weights = {
        "external": 20,
        "public": 20,
        "internet": 20,
        "internal": 5,
        "none": 0,
        "unknown": 0,
    }

    identity_impact_weights = {
        "admin": 25,
        "privileged": 20,
        "service_account": 15,
        "standard": 5,
        "unknown": 0,
    }

    score += severity_weights.get(severity, 0)
    score += finding_type_weights.get(finding_type, 0)
    score += exposure_weights.get(exposure, 0)
    score += identity_impact_weights.get(identity_impact, 0)

    return min(score, 100)


def recommended_action(score: int) -> str:
    if score >= 90:
        return "Immediate human review required. Consider containment or access revocation."
    if score >= 70:
        return "Human review required. Validate activity and prepare remediation."
    if score >= 40:
        return "Monitor and investigate if correlated with other suspicious activity."
    return "Log and monitor."