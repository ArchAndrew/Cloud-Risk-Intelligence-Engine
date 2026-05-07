#map finding to NIST / CIS / HIPAA controls
def map_controls(finding_type: str) -> dict:
    """
    Maps security finding types to common enterprise control frameworks.
    """

    finding_type = finding_type.lower()

    mappings = {
        "privilege_escalation": {
            "nist_800_53": ["AC-6", "AU-12", "SI-4"],
            "cis_aws": ["1.16", "1.20", "3.1"],
            "hipaa_security_rule": ["164.308(a)(4)", "164.312(a)(1)", "164.312(b)"],
        },
        "credential_exfiltration": {
            "nist_800_53": ["IA-5", "AC-6", "IR-4", "SI-4"],
            "cis_aws": ["1.4", "1.5", "1.16"],
            "hipaa_security_rule": ["164.308(a)(5)", "164.312(a)(2)", "164.312(b)"],
        },
        "public_exposure": {
            "nist_800_53": ["AC-3", "AC-4", "SC-7", "SI-4"],
            "cis_aws": ["2.1.1", "2.1.2", "4.1"],
            "hipaa_security_rule": ["164.312(a)(1)", "164.312(e)(1)"],
        },
        "brute_force": {
            "nist_800_53": ["AC-7", "IA-2", "SI-4"],
            "cis_aws": ["1.5", "3.1"],
            "hipaa_security_rule": ["164.308(a)(5)", "164.312(d)"],
        },
        "crypto_mining": {
            "nist_800_53": ["SI-3", "SI-4", "IR-4"],
            "cis_aws": ["3.1", "4.2"],
            "hipaa_security_rule": ["164.308(a)(1)", "164.312(b)"],
        },
        "unusual_region_activity": {
            "nist_800_53": ["AC-6", "AU-12", "SI-4"],
            "cis_aws": ["3.1", "3.14"],
            "hipaa_security_rule": ["164.308(a)(1)", "164.312(b)"],
        },
    }

    return mappings.get(
        finding_type,
        {
            "nist_800_53": ["SI-4"],
            "cis_aws": ["3.1"],
            "hipaa_security_rule": ["164.308(a)(1)"],
        },
    )