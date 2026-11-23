# Turf Homebrew Tap

Homebrew tap for [Turf](https://github.com/turfbuild/turf). Turf™ is a
self-hosted, autonomous infrastructure-as-code tool, built on OpenTofu™. It
deploys the stack an AI factory runs on and keeps it that way, with an agent
overseeing.

```sh
brew install restatedev/tap/restate-server turfbuild/tap/turf
turf license accept             # accept the Turf license terms, once per machine
brew services start turf        # this user's Turf engine, now and at every login
```

`turf license accept` accepts the
[Turf Community Edition License](https://turf.build/license/v1/) and records it
in `~/.turf/license.json`. No Turf binary does any work until the terms are
accepted: the engine service waits for the record and starts within seconds of
it. `TURF_ACCEPT_EULA=yes` in your shell accepts for the processes started from
that shell only; it does not reach the service. Every way to accept, per
binary: https://turf.build/docs/start/install/#accept-the-license.

This installs `turf` (the CLI), `turf-mcp-server`, `turf-engine`,
`turf-builtin-provider` and `turf-ui` (the Turf console), plus `restate-server`
from Restate's own tap, which the engine runs on. Homebrew loads a formula from a third-party tap only when you
name it, so the command names both; it also upgrades a 0.x install, where
`brew upgrade turf` alone stops at restate-server. Supported on macOS (Apple
Silicon + Intel) and Linux (x86_64 + arm64). On Linux the CLI is built without
CGO, so voice/audio input is inactive; text chat and all MCP tooling work fully.

## Connect your agent

One command registers `turf-mcp-server` with the agents on your machine — Claude
Code, Claude Desktop, Cursor, Codex, Gemini CLI, VS Code and others. It finds the
ones you have, lets you pick, and writes each config with the server's absolute
path, so an app launched from the Dock finds it too (Node 18+;
[add-mcp](https://github.com/neon-solutions/add-mcp) is Neon's open-source
installer):

```sh
npx add-mcp@2 "$(command -v turf-mcp-server)" --name turf -g
```

Without Node, the agent's own command does the same, e.g.
`claude mcp add turf --scope user -- turf-mcp-server`. In Claude Code and Claude
Desktop, Turf runs on your Claude subscription (no model API key). Then, in your
agent: `/turf:guide`. Per-client setup is on the
[turfbuild org page](https://github.com/turfbuild#connect-your-agent).

## The Turf CLI

`turf chat` and `turf up` are Turf's own agent: the same server and engine, driven
by a model you bring (`ANTHROPIC_API_KEY`, a local model, or a private endpoint).
Its README: https://github.com/turfbuild/turf.

## Telemetry

The Turf engine sends anonymous usage telemetry to Turf LLC by default: the
version, the platform, and counts of resources, changes and runs, never their
contents. `turf telemetry off`, then `brew services restart turf`, turns it
off. With Homebrew's analytics off (`brew analytics off` or
`HOMEBREW_NO_ANALYTICS`), the service starts with it off. The field list is at
https://turf.build/telemetry.

## Community

Questions and ideas: https://turf.build/discord/. A problem with the formula or
the service is an issue here; a bug in Turf goes to
https://github.com/turfbuild/turf/issues. Release notes by email:
https://turf.build/newsletter/. Everything else: https://turf.build/community/.

## License

Turf is proprietary software under the
[Turf Community Edition License 1.0](https://turf.build/license/v1/). It is free
for individuals, education and small businesses within the Community limits.
Government and larger organizations need a commercial license
(https://turf.build/licensing/). Anyone may evaluate Turf, not in production,
for 30 days. Accept the terms with `turf license accept` (or
`TURF_ACCEPT_EULA=yes` in a process's environment) before first use. Releases
1.0 through 1.4 keep the PolyForm Noncommercial License 1.0.0 they shipped
with. The `turf` CLI's source is open source (MPL-2.0). The formula installs
`LICENSE`, `STANDARD-TERMS.md` and `NOTICE` beside the binaries, and
`turf license` prints all three. Release notes:
https://github.com/turfbuild/turf/releases.

Turf™ is a trademark of Turf LLC. OpenTofu™ is a trademark of The Linux
Foundation. Turf is not affiliated with or endorsed by the Linux Foundation or
the OpenTofu project.
