## Preserve source detail and make retrieval usable

A commitment might be buried in a Slack thread with ten replies. We wanted search to find the conversation and give the agent a way back to the original messages. We retained every raw event in MongoDB and embedded the thread summary, so a noisy exchange contributed one compact representation to Qdrant.

## How a thread entered the graph

1. Store each incoming event in MongoDB. An async task checks the thread ID and assembles the conversation.
2. A decision model gates routing into downstream ingestion. Mahen fine-tuned ModernBERT for System 1, the first AI layer.
3. Generate a 5W1H summary with an LLM. Capture participants, the substance of the conversation, and linked issues.
4. Build the Work Graph at ingestion and store it in MongoDB. Embed the summary in Qdrant with metadata for participants, visibility, topics, project, and group.
5. On a match, use the stored links to bring related tickets into query context. Raw messages remain available for deeper inspection.

## Reuse the same inputs when ingestion changes

We captured events from the demo Slack once and stored them in MongoDB. Changes to ingestion could be tested by replaying the captured events through the same pipeline. That kept inputs stable and avoided repeated reads from Slack and its rate limits.

The summary is a trade-off. It gives search a coherent unit and reduces noise, while a detail that never appears in the summary can be harder to find. I would test rare identifiers and exact details separately and use authorized raw-message retrieval where it improves recall.
