# Machine-Lite | AI-Assisted Cloud Risk Intelligence Platform

From AWS Security Events to Executive & Analyst Intelligence

---

## Executive Summary

Machine-Lite is an AI-assisted cloud risk intelligence platform that transforms raw AWS security findings into scored, enriched, and actionable security intelligence. I designed and implemented this platform to address a common enterprise problem: security teams receive large volumes of findings from multiple tools, but many alerts lack business context, compliance impact, executive summaries, and durable evidence for investigations.

The platform ingests security events through Amazon EventBridge, normalizes the incoming data, calculates a deterministic and explainable risk score, maps findings to compliance frameworks, invokes Amazon Bedrock (Nova Lite) to generate executive and analyst narratives, stores immutable evidence in Amazon S3, sends critical alerts through Amazon SNS, and forwards enriched findings to Splunk Enterprise for executive dashboards and analyst investigations.

Machine-Lite demonstrates how serverless architecture, generative AI, and disciplined security engineering can be combined to create a cost-efficient cloud-native security platform.

<img src= https://github.com/ArchAndrew/Cloud-Risk-Intelligence-Engine/blob/main/diagrams/Cloud-Risk-Intelligence-Engine_Diagram.png style="width:1200px;">

---

## Business Problem

Security teams often struggle with five recurring challenges:

1. Alert fatigue caused by large volumes of unprioritized findings.
2. Lack of consistent business impact statements.
3. Manual compliance mapping to frameworks such as NIST 800-53, CIS AWS Foundations, and HIPAA.
4. Limited evidence preservation for forensic review and audit.
5. Executive stakeholders receiving highly technical alerts without actionable summaries.

As a result, analysts spend significant time manually triaging findings, writing summaries, and correlating regulatory impact. Critical findings may be delayed, and institutional knowledge is often lost across incident response cycles.

Machine-Lite was created to reduce this operational friction by automatically converting raw cloud findings into structured risk intelligence.

---

## Solution Overview

Machine-Lite implements the following end-to-end workflow:

1. AWS security findings are submitted to Amazon EventBridge.
2. Lambda Normalizer standardizes incoming event structure.
3. Lambda Risk Engine calculates a deterministic risk score.
4. Compliance controls are mapped to relevant frameworks.
5. Amazon Bedrock generates executive and analyst summaries.
6. High-risk findings trigger Amazon SNS notifications.
7. Enriched results are written to Amazon S3 as immutable evidence.
8. Findings are forwarded to Splunk Enterprise through Cloudflare Tunnel.
9. Executive and analyst dashboards provide operational visibility.


---

## Architecture Overview

### Core Services

- Amazon EventBridge
- AWS Lambda (Normalizer, Risk Engine, Splunk Forwarder)
- Amazon Bedrock (Nova Lite)
- Amazon S3 (Versioned Evidence Store)
- Amazon SNS (Human-in-the-Loop Alerts)
- AWS IAM
- Amazon CloudWatch
- Cloudflare Tunnel (TLS)
- Splunk Enterprise
- Terraform
- Python

### Key Outcomes

- Deterministic, explainable risk scoring before AI enrichment
- Compliance-aware security analysis
- AI-generated executive and analyst summaries
- Immutable evidence preservation
- Human approval and escalation workflows
- Executive and analyst dashboards

<img src= https://github.com/ArchAndrew/Cloud-Risk-Intelligence-Engine/blob/main/screenshots/key-outcomes-splunk-forwarding-enabled.png style="width:900px;">

---

## Business Outcomes

Machine-Lite converts technical security telemetry into business-aligned intelligence by providing:

- Prioritized risk scoring
- Executive-ready narratives
- Analyst investigation guidance
- Compliance impact analysis
- Automated alerting
- Durable evidence retention
- SIEM-based visibility

This reduces manual triage effort and accelerates decision-making.

---

## Event Processing Workflow

### Layer 1 – Event Sources
CloudTrail, GuardDuty, Security Hub, AWS Config, and simulated findings.

### Layer 2 – Event Ingestion
Amazon EventBridge decouples event producers from downstream processing.

### Layer 3 – Normalization
Lambda Normalizer aligns events to a common schema.

### Layer 4 – Deterministic Risk Scoring
Lambda Risk Engine calculates risk score and classification.

### Layer 5 – AI Enrichment
Amazon Bedrock generates executive and analyst summaries.

### Layer 6 – Evidence Preservation
Amazon S3 stores versioned JSON evidence artifacts.

### Layer 7 – Human-in-the-Loop Governance
Amazon SNS emails analysts when risk score is 90 or higher.

### Layer 8 – SIEM Forwarding
S3 events trigger Lambda Splunk Forwarder, which sends data to Splunk HEC.

### Layer 9 – Observability
CloudWatch logs provide operational visibility.

### Layer 10 – Dashboards
Splunk dashboards present executive and analyst intelligence.

---

## Enterprise Design Decisions and Trade-Offs

### Deterministic Scoring Before AI
I intentionally calculate the risk score before invoking Amazon Bedrock. This ensures the authoritative decision remains explainable and repeatable.

**Trade-Off:** AI is limited to contextual enrichment rather than autonomous decision-making.

### Serverless-First Architecture
The platform uses EventBridge, Lambda, and S3 to minimize idle costs.

**Trade-Off:** Debugging distributed workflows requires strong logging and tracing.

### S3 as Evidence Store
All enriched findings are written to versioned JSON objects.

**Trade-Off:** Querying historical data requires analytics tooling such as Splunk or Athena.

### Cloudflare Tunnel for Splunk Connectivity
Cloudflare provides TLS-secured external connectivity without managing public certificates.

**Trade-Off:** This approach is appropriate for lab and demonstration environments rather than production.

### Local Splunk Deployment
Splunk Enterprise runs locally to reduce cost while preserving realistic SIEM integration.

**Trade-Off:** Operational management remains the responsibility of the architect.

---

## AI Governance and Human-in-the-Loop Controls

Amazon Bedrock is used strictly as an enrichment layer. The model generates:

- Executive summaries
- Analyst summaries
- Recommended next steps
- Compliance impact explanations

The AI does not perform autonomous remediation or override deterministic scoring.

Critical findings trigger Amazon SNS notifications to ensure a human analyst reviews the event before any containment actions are taken.

**Insert image here:** `03-iam-bedrock-and-sns-policy.png`

**Insert image here:** `04-cloudwatch-bedrock-success.png`

**Insert image here:** `07-sns-email-critical-alert.png`

---

## Evidence Preservation and Auditability

Each processed finding is stored in Amazon S3 with:

- Original event data
- Risk score and classification
- Compliance mappings
- AI-generated summaries
- SNS publish status
- Processing metadata

Versioning and lifecycle policies support forensic retention and auditability.

**Insert image here:** `08-s3-ai-enriched-evidence-object.png`

---

## Splunk Dashboards

### Executive Overview
High-level risk trends and KPI summaries.

**Insert image here:** `09-splunk-executive-overview.png`

### Detection Analytics
Threat timelines, MITRE ATT&CK distributions, and high-risk identities.

**Insert image here:** `10-splunk-detection-analytics.png`

### Compliance Intelligence
Framework and control impact visualizations.

**Insert image here:** `11-splunk-compliance-intelligence.png`

### Incident Drilldown
Detailed analyst investigation workspace.

**Insert image here:** `12-splunk-incident-drilldown.png`

---

## Security Controls Matrix

| Control Area | Implementation | Security Outcome |
|------------|----------------|-----------------|
| IAM Least Privilege | Scoped Lambda execution role | Reduces privilege exposure |
| AI Governance | Bedrock used only for enrichment | Prevents autonomous decisions |
| Evidence Retention | S3 versioning | Supports forensic preservation |
| Human Approval | SNS notifications | Ensures analyst oversight |
| Monitoring | CloudWatch and Splunk | Improves visibility |
| Infrastructure as Code | Terraform | Enables repeatability |

---

## Compliance Mapping

Machine-Lite maps findings to:

- NIST 800-53
- CIS AWS Foundations Benchmark
- HIPAA Security Rule

These mappings are intended for educational and architectural demonstration purposes and do not represent formal certification.

---

## Cost Control Strategy

I intentionally designed Machine-Lite to operate with minimal ongoing cost.

- Serverless services eliminate idle infrastructure.
- Amazon Bedrock is invoked only when findings are processed.
- Local Splunk avoids managed SIEM licensing costs.
- Cloudflare Tunnel replaces paid tunneling solutions.
- S3 lifecycle policies control storage retention.

Typical lab costs remain very low while preserving enterprise realism.

---

## Threat Model

Machine-Lite is designed to detect and contextualize findings such as:

- Privilege escalation
- Credential exfiltration
- Public exposure
- Data exfiltration
- Crypto mining
- IAM anomalies
- Disabled security guardrails

---

## Incident Walkthrough

A simulated privilege escalation event with critical severity, external exposure, and administrative identity impact is submitted to EventBridge.

The platform calculates a risk score of 100, classifies the event as critical, maps compliance impacts, generates AI summaries, sends an SNS email alert, stores the evidence in S3, and forwards the enriched event to Splunk.

This demonstrates a complete detection-to-intelligence workflow.

---

## Lessons Learned

- I implemented deterministic scoring before AI enrichment to preserve explainability.
- I used Amazon Bedrock to automate executive and analyst narratives.
- I replaced ngrok with Cloudflare Tunnel to simplify TLS connectivity.
- I integrated SNS to create a human-in-the-loop escalation workflow.
- I preserved enriched findings as versioned evidence artifacts in S3.

---

## Interview Talking Points

- Why did you score findings before invoking AI?
- Why did you use S3 as an evidence store?
- How does SNS support governance?
- What trade-offs did you make to reduce cost?
- How does Bedrock add business value?
- Why did you choose a serverless architecture?

---

## Repository Structure

```text
terraform/
src/
dashboards/
docs/
diagrams/
screenshots/
sample-data/
scripts/
```

---

## Deployment Summary

The entire platform is provisioned using Terraform and implemented in Python. All infrastructure, IAM policies, environment variables, and service integrations are deployed reproducibly through Infrastructure as Code.

---

## Final Summary

Machine-Lite demonstrates how AWS-native services, generative AI, and disciplined security engineering can be combined to transform raw cloud security findings into executive and analyst intelligence.

The platform is deterministic, explainable, cost-efficient, and designed with governance, compliance, and evidence preservation in mind.

---

thee_architect_was_Here

