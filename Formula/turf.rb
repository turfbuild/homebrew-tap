class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.16.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.16.0/turf_v0.16.0_darwin_arm64.tar.gz"
      sha256 "3584fc69038aea4a2555db4f9d3dedb48729c6382fe92fb19f312548448de681"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.16.0/turf_v0.16.0_darwin_amd64.tar.gz"
      sha256 "7aeb068b560b483d0d775d597436fe8a1c418158e40105a243468a399572e422"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.16.0/turf_v0.16.0_linux_arm64.tar.gz"
      sha256 "e5912fd0d725212f2dbb408282dc6cc9d37668b99ac158deb5685a04ca33638d"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.16.0/turf_v0.16.0_linux_amd64.tar.gz"
      sha256 "cdc32e4b053c7df0cff8feeb7992539d4d8dad9a6e12b9fff5bcb380555ded28"
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
