---
description: Delegate an independent .NET practices review of a changeset — asynchrony, cancellation, background work, streaming, I/O boundaries, concurrency shape, and modern API usage — to the dotnet-practices-reviewer subagent and report the findings.
argument-hint: [changeset]
---

# .NET Practices Review

Delegate a read-only .NET practices review to the `dotnet-practices-reviewer` subagent (`.zcode/agents/dotnet-practices-reviewer.md`), which judges the change for proper use of asynchrony and other advanced .NET mechanisms against current Microsoft guidance and against the mechanisms built into this solution — the `TimeProvider` single owner, the cancellation convention on the Core contracts, the database-enforced concurrency, the hosted dispatch pattern, factory-built HTTP clients, the storage streaming seam, the telemetry single owner, and the plugin load contract.

Review scope: $ARGUMENTS

Default scope when none is given: the current working-tree diff (or, on a branch, the diff from the merge base with the comparison target). If your runtime has no subagent mechanism, read the subagent definition and execute its Procedure yourself, reporting in its Output format. Lead with the verdict, list every finding, and resolve them before completion — the primary agent owns delivery. Do not stage, commit, or push while reviewing.
