from schemas import DEFAULT_SOURCE, DEFAULT_DETAIL_TYPE


def parse_security_event(event: dict) -> dict:
    detail = event.get("detail", {})

    return {
        "event_id": event.get("id", "unknown"),
        "source": event.get("source", DEFAULT_SOURCE),
        "detail_type": event.get("detail-type", DEFAULT_DETAIL_TYPE),
        "account": event.get("account", "unknown"),
        "region": event.get("region", "unknown"),
        "event_time": event.get("time", "unknown"),
        "finding_type": detail.get("finding_type", "unknown"),
        "original_severity": detail.get("severity", "unknown"),
        "exposure": detail.get("exposure", "unknown"),
        "identity_impact": detail.get("identity_impact", "unknown"),
        "original_event": event,
    }