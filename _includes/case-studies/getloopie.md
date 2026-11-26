## What we built

- **A decision gate for ingestion.** A decision model routed incoming work before deeper processing. Mahen fine-tuned ModernBERT for System 1, our first AI layer.
- **Compact retrieval with full history.** MongoDB held raw events and the Work Graph. We embedded 5W1H thread summaries in Qdrant and pulled linked issues into context when a conversation matched.
- **Deterministic control with specialist agents.** Application code routed requests to views such as Scrum Master and Product Manager. The sub-agents used OpenAI SDK tools. The orchestrator assembled the final response and posted it to Slack.
- **A code-enforced access boundary.** All tools had permission filters applied in code, including vector retrieval and deep-dive graph traversal. A public thread got public evidence. A private thread could draw on evidence shared among its participants.

We integrated Slack, Jira, Linear, Jira Service Management, Microsoft Teams, and Fathom call summaries.
