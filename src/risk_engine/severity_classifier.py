#convert score into low / medium / high / critical

def classify_severity(score: int) -> str:
    """
    Converts numeric risk score into business-friendly severity classification.
    """

    if score >= 85:
        return "critical"

    if score >= 70:
        return "high"

    if score >= 40:
        return "medium"

    return "low"