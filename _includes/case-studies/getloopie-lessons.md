## We started repeatable evals too late

We began with manual inspection. A demo answer could look good without telling us which part of the system worked. The synthetic workspace and replay harness gave us stable inputs and let us inspect graph construction, retrieval, routing, and groundedness independently. I would create a small version of that dataset at the start of the next product and reserve a holdout set alongside the examples we revise during development.

## Access rules reached across two stores

Keeping the graph and vector index separate made permissioning harder. Qdrant carried participant and visibility metadata while MongoDB held the underlying messages and links. We enforced access in tool code and planned PostgreSQL consolidation to bring those representations together. I would test the public and private paths against the same scenarios before changing storage, including graph expansion as well as vector search.

## A valid response shape gave limited assurance

Pydantic checked structure. Sub-agents returned neither citations nor source IDs, so the production response had no claim-level evidence contract. We used offline groundedness evaluation to spot unsupported claims. I would make evidence IDs part of the tool and sub-agent response contract so the system can trace important claims to authorized sources.

## Summary embeddings can hide details

Embedding summaries helped keep retrieval compact. It also meant that a detail omitted from the summary could be difficult to recover through semantic search. We kept raw history. I would add tests for exact ticket IDs and rare terms, then compare summary retrieval with an authorized lookup into that raw history.
