#calculate risk score based on severity, finding type, exposure, identity impact

def calculate_risk_score(detail: dict) -> int:
    """
    Calculates a risk score from 0-100 based on severity, finding type,
    exposure, and identity impact.
    """

    score = 0

    severity = detail.get("severity", "medium").lower()
    finding_type = detail.get("finding_type", "unknown").lower()
    exposure = detail.get("exposure", "internal").lower()
    identity_impact = detail.get("identity_impact", "standard").lower()

    severity_weights = {
        "critical": 40,
        "high": 30,
        "medium": 15,
        "low": 5,
    }

    finding_type_weights = {
        "privilege_escalation": 25,
        "credential_exfiltration": 30,
        "public_exposure": 20,
        "malware": 25,
        "crypto_mining": 20,
        "brute_force": 15,
        "unusual_region_activity": 15,
        "unknown": 5,
    }

    exposure_weights = {
        "public": 20,
        "external": 15,
        "internal": 5,
        "none": 0,
    }

    identity_impact_weights = {
        "admin": 20,
        "privileged": 15,
        "standard": 5,
        "unknown": 0,
    }

    score += severity_weights.get(severity, 10)
    score += finding_type_weights.get(finding_type, 5)
    score += exposure_weights.get(exposure, 5)
    score += identity_impact_weights.get(identity_impact, 0)

    return min(score, 100)


def recommended_action(score: int) -> str:
    if score >= 85:
        return "Immediate human review required. Consider containment or access revocation."
    if score >= 70:
        return "Human review required. Validate activity and prepare remediation."
    if score >= 40:
        return "Monitor and investigate if correlated with other suspicious activity."
    return "Log and monitor."