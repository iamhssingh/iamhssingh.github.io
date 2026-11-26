## Make allocation decisions repeatable

Deckers planners relied on manual Python workflows and spreadsheet handoffs for inventory allocation and replenishment. I led engineering through Toptal and co-owned the roadmap with Planning and Supply Chain. We needed a common workflow planners could use across markets and an audit trail that explained each decision.

## Build around Excel and Oracle RMS

- **Spreadsheet intake.** The platform ingested large Excel SKU datasets with Python, NumPy, and Pandas. A standard pipeline replaced recurring manual handoffs.
- **Oracle RMS integration.** SOAP adapters handled the external contract, including schema changes and latency. Allocation logic stayed in the platform.
- **Multi-tenant deployment.** We used Lambda, API Gateway, EventBridge, S3, and RDS, with CloudFormation for infrastructure. We put structured logging, dashboards, and runbooks around the rollout.

## Verify that it could ship and operate across markets

We maintained at least 90% unit-test coverage and went from MVP to production in about two months. The platform rolled out across North America, EMEA, Japan, and China, and the infrastructure passed audit.
