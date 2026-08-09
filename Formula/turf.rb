class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.12.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.12.0/turf_v0.12.0_darwin_arm64.tar.gz"
      sha256 "efebf0caba73c217fe7e6819136b05b81680d117d71effda8590a4fa80cf8a2e"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.12.0/turf_v0.12.0_darwin_amd64.tar.gz"
      sha256 "dd45b64c70c3bc249dec7aa7519c6786d914f9c08c1f3c46a3d3a154cda93653"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.12.0/turf_v0.12.0_linux_arm64.tar.gz"
      sha256 "ac425ffc94f336c4a17d6a1f6e6fd34e2b3b49b6e05933fcf7b5bd34c0fd2d9c"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.12.0/turf_v0.12.0_linux_amd64.tar.gz"
      sha256 "58c40eec07dabf301fa3016993fcd155b70db79474faf0dfb280da02322cae3d"
    end
  end

  def install
    # Install both binaries: the CLI shells out to turf-mcp-server via PATH.
    bin.install "turf", "turf-mcp-server"
    # Keep the evaluation license and third-party notices with the install.
    prefix.install "LICENSE", "NOTICE"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Turf is alpha / pre-release evaluation software, provided under the PolyForm
      Free Trial License 1.0.0 (no warranty; see #{opt_prefix}/LICENSE). The `turf`
      CLI is open source (MPL-2.0); component notices are in #{opt_prefix}/NOTICE.
      By installing and using Turf you accept those terms. Please don't redistribute
      the binaries.

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
