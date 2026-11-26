## Customers needed connectors faster

Enterprise deployments depended on systems such as NetSuite, Dun & Bradstreet, and RDC. The old integration framework accounted for roughly **30% of on-call incidents**, and new integrations could take weeks. Customer delivery and operational support both depended on the same part of the platform.

## Isolate execution and make differences configurable

I extracted integration execution into an isolated serverless service. A deployment's configuration selected the connector, and the plug-in handled its vendor-specific contract. This gave the team one execution boundary and a way to add vendor behavior without spreading it through the main workflow platform.

## Track delivery time and the scope of reuse

We delivered NetSuite, Dun & Bradstreet, and RDC connectors on the shared service. The service supported roughly 250 configurations, and connector lead time fell from weeks to days.
