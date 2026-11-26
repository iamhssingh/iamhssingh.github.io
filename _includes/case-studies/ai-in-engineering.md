## Why I criticize spec-driven development

I rolled out spec-driven development across **50+ engineers**. A spec helps a team agree on the problem, but it can turn into a waterfall handoff if product and engineering are expected to finish the requirements, high-level design, and low-level design before anyone works through a real implementation.

The cost shows up when we discover a bad assumption. If a small implementation decision requires reopening and approving the spec, teams either wait for the document or work around it. If the team reviews the whole feature at the end, it finds missing product behavior when more code depends on the original assumption. AI can produce a large, internally consistent PR from that assumption before anyone has tested it with a user or a realistic example.

## What I put in the spec

- **Product requirements.** Agree on the user problem, the intended behavior, and the scenarios that would make the change acceptable.
- **High-level design.** Agree on the boundaries that are expensive to reverse, such as which service owns the data, what a public contract promises, and where permissions are enforced.
- **Low-level design.** Let the author adjust module structure and implementation details as the work develops. Update the spec when feedback changes the agreed behavior, contract, or architecture.

The part of Agile I want to preserve is learning from working software in small increments. I prefer to implement a small slice and review it while the decisions are still easy to change. That lets the spec capture what we learned.

## How I review agent-assisted changes

I tried four specialist roles for design conventions, secure coding, test cases, and general code review. The passes increased token cost, so I focus extra review on changes where a missed defect has a larger consequence.

I start with **Given / When / Then** to find missing behavior. For example, given that the first create request committed but the response timed out, when the client retries with the same idempotency key, then it gets the same record. The scenario checks the failure that can create duplicates. I also ask a separate agent to reconstruct the high-level design from the PR and compare it with the decisions we agreed on.

I used `!good` and `!bad` on review comments to collect examples of feedback worth keeping. I periodically curated those examples into the repository. Module READMEs gave agents and humans the local context to review the next change.
