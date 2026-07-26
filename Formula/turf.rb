class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.9.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.9.0/turf_v0.9.0_darwin_arm64.tar.gz"
      sha256 "7eefd5d4cf4f30a5f064d5097eaae4484cd2c71dc269b034c6c57bc09b5cdb17"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.9.0/turf_v0.9.0_darwin_amd64.tar.gz"
      sha256 "ef52a643fb39e711611340167e8a4ebbd5fe3e2f1861c3fc61cc63aef55aa106"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.9.0/turf_v0.9.0_linux_arm64.tar.gz"
      sha256 "fab146ac0b83447b52288775f5685d0dfc6c3df3b2cc59b3ad92f659cd8db18d"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.9.0/turf_v0.9.0_linux_amd64.tar.gz"
      sha256 "52b672b45ae65ec6845b6448641578f61ac5e838bd33e6d5cf2fef34d47e0f74"
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
