class Turf < Formula
  desc "Self-hosted, autonomous infrastructure-as-code tool built on OpenTofu"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "1.4.0"
  # The release archive is proprietary: the Turf Community Edition License 1.0
  # (https://turf.build/license/v1/, the archive's LICENSE), which has no SPDX id.
  # The turf CLI's own source is MPL-2.0. Releases 1.0 through 1.4 shipped under
  # PolyForm-Noncommercial-1.0.0.
  license :cannot_represent

  # The local engine (`turf-mcp-server engine run`, the service below) runs on
  # restate-server, which is BUSL-1.1 and never redistributed in Turf's tarball:
  # it comes from Restate's own tap.
  depends_on "restatedev/tap/restate-server"

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v1.4.0/turf_v1.4.0_darwin_arm64.tar.gz"
      sha256 "bbabaac0692f43785aaa97220bde71946aa302c82246b93cfddf94f69f396a9c"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v1.4.0/turf_v1.4.0_darwin_amd64.tar.gz"
      sha256 "68e7baf5f662fee7b4adeec387485cc49026bf3099e4f27afa1ea04415251b7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v1.4.0/turf_v1.4.0_linux_arm64.tar.gz"
      sha256 "06669338bd002cbb2bde2d8b59142e7239ab0d73726fb124413169d7282d0294"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v1.4.0/turf_v1.4.0_linux_amd64.tar.gz"
      sha256 "4f2757eaab650d84fed525c021a3e469b81062c9ffaf6b9f263f03bc424234c6"
    end
  end

  def install
    # The CLI shells out to turf-mcp-server via PATH; the server connects to the
    # local engine, which finds turf-engine (and turf-engine its built-in
    # provider) and the console, turf-ui, beside the server binary.
    bin.install "turf", "turf-mcp-server", "turf-engine", "turf-builtin-provider", "turf-ui"
    # Keep the license, the standard terms it incorporates and the third-party
    # notices with the install.
    prefix.install "LICENSE", "STANDARD-TERMS.md", "NOTICE"
    doc.install "README.md"
  end

  # This user's Turf engine: restate-server, turf-engine and the Turf console
  # (turf-ui, http://127.0.0.1:8873), supervised in ~/.turf/engine. Every server (each `turf` command, each MCP client) connects
  # to it; a rollout waiting for approval survives them. Extra environment for
  # providers goes in ~/.homebrew/services/turf.env.
  service do
    run [opt_bin/"turf-mcp-server", "engine", "run"]
    keep_alive crashed: true
    log_path var/"log/turf-engine.log"
    error_log_path var/"log/turf-engine.log"
    # Homebrew's analytics opt-out (HOMEBREW_NO_ANALYTICS, or `brew analytics off`)
    # is its do-not-track: the engine starts with its usage telemetry off. Read
    # when `brew services` writes the service.
    env = { PATH: std_service_path_env }
    no_analytics = !ENV.fetch("HOMEBREW_NO_ANALYTICS", "").empty? ||
                   (defined?(Utils::Analytics) && Utils::Analytics.disabled?)
    env[:DO_NOT_TRACK] = "1" if no_analytics
    environment_variables env
  end

  def caveats
    <<~EOS
      First, accept the Turf license terms (https://turf.build/license/v1/):
        turf license accept
      This records your acceptance in ~/.turf/license.json. No Turf binary does
      any work until the terms are accepted: no engine starts, and the service,
      if you run it, waits and starts within seconds. TURF_ACCEPT_EULA=yes in
      your shell accepts for the processes started from that shell only: it does
      not reach the service.

      The service is optional: the engine starts when a tool first needs it;
      `brew services start turf` starts it at login instead:
        brew services start turf
      `turf-mcp-server engine status` says where it runs and how it was started.
      The Turf console is at http://127.0.0.1:8873 (read-only, and only you can
      open it: sign this browser in once with `turf console`; for the service,
      TURF_CONSOLE_ADDR=off in ~/.homebrew/services/turf.env turns it off).
      After an upgrade, restart the engine, which an upgrade leaves running:
        turf-mcp-server engine stop
      (the next request starts the new one), or, if you run the service:
        brew services restart turf
      and reconnect your agent's MCP server. A minor upgrade (1.3 to 1.4) stops any
      rollout still running on the old engine; what was applied is kept, so run
      `up` again, then `plan`, to finish it.

      Connect your agent — Claude Code, Claude Desktop, Cursor, Codex, Gemini CLI,
      VS Code and others — in one command (Node 18+), picking the ones you use:
        npx add-mcp@2 #{HOMEBREW_PREFIX}/bin/turf-mcp-server --name turf -g
      or with the agent's own command: claude mcp add turf --scope user -- turf-mcp-server
      In Claude Code and Claude Desktop, Turf runs on your Claude subscription, no
      model API key. Then, in your agent: /turf:guide. Per-client setup:
      https://github.com/turfbuild#connect-your-agent
      Turf's own agent, `turf chat`, needs a model API key.

      Turf is proprietary software under the Turf Community Edition License 1.0
      (#{opt_prefix}/LICENSE, with #{opt_prefix}/STANDARD-TERMS.md;
      https://turf.build/license/v1/). Free for individuals, education and small
      businesses within the Community limits. Government and larger organizations
      need a commercial license: https://turf.build/licensing/. Anyone may evaluate
      Turf, not in production, for 30 days. The `turf` CLI's source is open
      source (MPL-2.0); component notices are in #{opt_prefix}/NOTICE, and
      `turf license` prints all three files.

      Turf sends anonymous usage telemetry to Turf LLC by default: the version, the
      platform, and counts of resources, changes and runs, never their contents
      (https://turf.build/telemetry). To turn it off:
        turf telemetry off
      then restart the engine: `turf-mcp-server engine stop` (the next request
      starts it again), or `brew services restart turf` if you run the
      service. DO_NOT_TRACK in your shell does not reach the service; put it in
      ~/.homebrew/services/turf.env instead. With Homebrew's analytics off
      (`brew analytics off` or HOMEBREW_NO_ANALYTICS), the service starts with
      telemetry off.

      The released CLI is built without CGO on all platforms, so voice/audio input is
      inactive; text chat and all MCP tooling work fully.

      Every release artifact is signed and logged in the public Sigstore transparency
      log. To verify:
        gh attestation verify #{bin}/turf --repo turfbuild/turf
      The server-binary and container-image recipes are in each release's notes:
      https://github.com/turfbuild/turf/releases/latest
    EOS
  end

  test do
    # version.to_s (scanned from the URL) keeps this correct across releases.
    assert_match version.to_s, shell_output("#{bin}/turf --version")
    # --version needs no license acceptance and names the license.
    assert_match "Turf Community Edition License", shell_output("#{bin}/turf --version")
    assert_match version.to_s, shell_output("#{bin}/turf-mcp-server --version")
    assert_match version.to_s, shell_output("#{bin}/turf-ui --version")
  end
end
