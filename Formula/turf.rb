class Turf < Formula
  desc "Self-hosted, autonomous infrastructure-as-code tool built on OpenTofu"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "1.1.0"
  # The license of the release archive (its LICENSE carries the Required Notice).
  # The turf CLI alone is MPL-2.0; the archive as a whole is the Larger Work.
  license "PolyForm-Noncommercial-1.0.0"

  # The local engine (`turf-mcp-server engine run`, the service below) runs on
  # restate-server, which is BUSL-1.1 and never redistributed in Turf's tarball:
  # it comes from Restate's own tap.
  depends_on "restatedev/tap/restate-server"

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v1.1.0/turf_v1.1.0_darwin_arm64.tar.gz"
      sha256 "140d60fe93e3cd8458e1be2e937394d16a7dfa76ecd2e94093c967b4da0a7671"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v1.1.0/turf_v1.1.0_darwin_amd64.tar.gz"
      sha256 "c7ce69a0bb7ae5d264f65aabf23c1fadb6718a68a1b0d08f3c7e1a077f43d3e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v1.1.0/turf_v1.1.0_linux_arm64.tar.gz"
      sha256 "cf73be8ff31f92747f77450218d927150a7822569a05a99ea349441d619c7baa"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v1.1.0/turf_v1.1.0_linux_amd64.tar.gz"
      sha256 "029fb33f46a56860ecbc78ed272b3c618985e49bcbe3acf56c417d5773cf6744"
    end
  end

  def install
    # The CLI shells out to turf-mcp-server via PATH; the server connects to the
    # local engine, which finds turf-engine (and turf-engine its built-in
    # provider) beside the server binary.
    bin.install "turf", "turf-mcp-server", "turf-engine", "turf-builtin-provider"
    # Keep the license and third-party notices with the install.
    prefix.install "LICENSE", "NOTICE"
    doc.install "README.md"
  end

  # This user's Turf engine: restate-server and turf-engine, supervised in
  # ~/.turf/engine. Every server (each `turf` command, each MCP client) connects
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
      Start the local Turf engine (and at every login from now on):
        brew services start turf
      `turf-mcp-server engine status` says where it runs. After an upgrade:
        brew services restart turf
      and reconnect your agent's MCP server. A minor upgrade (1.0 to 1.1) stops any
      rollout still running on the old engine; what was applied is kept, so run
      `up` again to finish it.

      Connect your agent — Claude Code, Claude Desktop, Cursor, Codex, Gemini CLI,
      VS Code and others — in one command (Node 18+), picking the ones you use:
        npx add-mcp@2 #{HOMEBREW_PREFIX}/bin/turf-mcp-server --name turf -g
      or with the agent's own command: claude mcp add turf --scope user -- turf-mcp-server
      In Claude Code and Claude Desktop, Turf runs on your Claude subscription, no
      model API key. Then, in your agent: /turf:guide. Per-client setup:
      https://github.com/turfbuild#connect-your-agent
      Turf's own agent, `turf chat`, needs a model API key.

      Turf is free for noncommercial use under the PolyForm Noncommercial License
      1.0.0 (no warranty; see #{opt_prefix}/LICENSE). Commercial use, including a
      company's internal use, needs a license: https://turf.build/licensing. The
      `turf` CLI is open source (MPL-2.0); component notices are in
      #{opt_prefix}/NOTICE, and `turf license` prints both files.

      Turf sends anonymous usage telemetry to Turf LLC by default: the version, the
      platform, and counts of resources, changes and runs, never their contents
      (https://turf.build/telemetry). To turn it off:
        turf telemetry off && brew services restart turf
      DO_NOT_TRACK in your shell does not reach the service; put it in
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
    assert_match version.to_s, shell_output("#{bin}/turf-mcp-server --version")
  end
end
