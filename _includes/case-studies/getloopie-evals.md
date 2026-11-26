## We started by eyeballing outputs

Reading a few agent responses helped us spot obvious problems. It was hard to tell whether a change improved the system or whether a plausible answer happened to come from a weak retrieval. We needed a workspace we could replay and expected outcomes we could inspect.

## Build a synthetic company that behaves like a team

We created a multi-user Slack workspace with roles across backend, frontend, mobile, product, scrum, leadership, sales, and customer success. We hand-wrote **100+ threads**, typically around ten messages each, across **two simulated weeks**. The same ticket could come up in product, engineering, and standup channels. We included private threads, Linear work items, and Fathom summaries. The workspace doubled as the product demo.

We stored the Slack events once in MongoDB and re-ingested them through a replay harness after changes. Golden questions such as a ticket status check pointed to expected linked threads. We manually reviewed unexpected returns and graph links. A valid extra result could expand the gold set. We refined the dataset over roughly **three to six months**.

## Inspect failures where they occur

A routing scenario checked that an infrastructure incident reached the appropriate engineering or product discussion. A private-thread scenario checked whether the agent could surface useful context to an authorized audience. Retrieval measured relevant and missing evidence, tool tests checked the selected action, and offline judges assessed whether the final answer followed from the evidence. The [architecture diagram](../#architecture) shows where each check attaches.

Repeated trials separated a workflow that could work once from one that kept working. We used `pass@k` for at least one successful trial and `pass^k` for success across all `k` trials. Pydantic validation in production checked response structure. Groundedness was assessed offline.
