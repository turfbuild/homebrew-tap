class Turf < Formula
  desc "Self-hosted, autonomous infrastructure-as-code tool built on OpenTofu"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.17.0"
  # The license of the release archive (its LICENSE carries the Required Notice).
  # The turf CLI alone is MPL-2.0; the archive as a whole is the Larger Work.
  license "PolyForm-Noncommercial-1.0.0"

  # The local engine (`turf-mcp-server engine run`, the service below) runs on
  # restate-server, which is BUSL-1.1 and never redistributed in Turf's tarball:
  # it comes from Restate's own tap.
  depends_on "restatedev/tap/restate-server"

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.17.0/turf_v0.17.0_darwin_arm64.tar.gz"
      sha256 "7674907585dde94e3e561566f9baa7700d3b95c81946253a79db2cbfefe2efc0"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.17.0/turf_v0.17.0_darwin_amd64.tar.gz"
      sha256 "606e7d256b73d74e03f6324c57e5f4b83e814c60889ea279e309f14c407580a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.17.0/turf_v0.17.0_linux_arm64.tar.gz"
      sha256 "5be89b19394261464d216fb9e1a9d0e73fb3ea88543f84f79de159d3190dbee5"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.17.0/turf_v0.17.0_linux_amd64.tar.gz"
      sha256 "f6ae1db59f89f0586824d7cb3069ff9b32a97baac50152807a2fdf7f9b6eb50c"
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
      `turf-mcp-server engine status` says where it runs. After an upgrade, finish
      or cancel any rollout waiting for approval, then `brew services restart turf`.

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

      Prefer your own MCP client? #{bin}/turf-mcp-server is on your PATH — register
      it and drive infrastructure from there (in Claude Code / Desktop it runs on
      your Claude subscription, no model API key):
        claude mcp add turf -- turf-mcp-server
      Per-client setup (Codex, Gemini, Cursor, VS Code, …):
      https://github.com/turfbuild#use-it-as-an-mcp-server

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
