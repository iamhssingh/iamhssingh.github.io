## Make the ticket link part of the data

A status question often spans product, engineering, and standup threads. We built the Work Graph during ingestion and kept conversation-to-ticket links in MongoDB. When a conversation matched, its linked tickets could join the context without rebuilding those relationships for each query.

## Put access control in the tools

A relevant item can still be off limits in the destination thread. We enforced access through application code shared by tool calls. Qdrant filtered candidate summaries before semantic top-k search and LLM reranking. The OpenAI SDK deep-dive graph tool applied the same policy to traversal and ticket expansion. Public threads received public evidence. Private threads were scoped to information shared among their participants.

For example, if a release date appears only in a private thread, a public status reply can use the public ticket and channel history. The private date stays outside the agent’s context for that reply.

## Where the split became difficult

MongoDB owned the graph and raw messages. Qdrant needed enough participant and visibility metadata to filter the vector index. We struggled with enforcing permissioning across both representations. We planned to consolidate documents, graph links, access metadata, and vectors in PostgreSQL so the data needed for access decisions and retrieval could live together. The deployed design used MongoDB and Qdrant.
