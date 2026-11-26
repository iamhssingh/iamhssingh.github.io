## Preserve a traceable history during migration

Certa customers relied on audit trails for regulated workflows. The migration added bursts to the normal event stream. The audit pipeline needed to absorb those bursts while preserving the records customers used to explain what happened.

## Why SQS, Lambda, and MongoDB

I put **Amazon SQS** between event producers and audit processing. The queue buffered bursts so the workflows emitting events and the workers writing them could scale independently. **AWS Lambda** fit that workload: workers could pick up queued work as traffic changed, and we could pay for execution as the backlog drained. [AWS Lambda pricing](https://aws.amazon.com/lambda/pricing/)

**MongoDB** stored the audit records. An audit event fits naturally in a document: it can carry its own context and event-specific details together. That made the database write a straightforward document insert. [MongoDB data modeling](https://www.mongodb.com/docs/manual/data-modeling/)

## Keep the Lambda write path lean

I wrote audit documents directly to MongoDB without an ORM. That avoided allocating and hydrating mapper objects in a path that ran repeatedly during the migration. Keeping the handler's working set small gave me room to use a lower memory setting if it could still handle the load.

Lambda duration charges are based on **configured memory multiplied by billed execution time**, measured in GB-seconds. Invocations are billed separately. Memory also affects the CPU available, so a smaller setting can take longer and erase the compute savings. In a hypothetical comparison, **512 MB for 100 ms** and **256 MB for 200 ms** both use 0.05 GB-seconds. The goal was to spend fewer GB-seconds processing the same workload. [AWS Lambda pricing](https://aws.amazon.com/lambda/pricing/) · [Lambda memory and CPU](https://docs.aws.amazon.com/lambda/latest/dg/configuration-memory.html)

## Interpret the performance in context

The migration peaked near **10,000 events per second**, with roughly **50 ms of Lambda execution**. End-to-end event delivery also includes queueing and storage. SOC audits, penetration tests, and client load tests checked compliance, security, and behavior under load.
