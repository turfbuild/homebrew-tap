class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.5.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.5.0/turf_v0.5.0_darwin_arm64.tar.gz"
      sha256 "c220a487f10f713fa6106d7f887e6ebf63cedf69ee429d09d6bcfb452d0335f1"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.5.0/turf_v0.5.0_darwin_amd64.tar.gz"
      sha256 "7b3a50e1d52af22f527b93f1d7c611e964a9aad69a14b9a767aea2dac97e63a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.5.0/turf_v0.5.0_linux_arm64.tar.gz"
      sha256 "c8b09a0f73579f88e9ffa62162419b293e3525dd091d6e669887c9571c8080ad"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.5.0/turf_v0.5.0_linux_amd64.tar.gz"
      sha256 "28b38e94b7ffaf178198b10e29e2844a15b314a799b659672bc8c899765fceac"
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

      On Linux, the turf CLI is built without CGO, so voice/audio input is inactive;
      text chat and all MCP tooling work fully.
    EOS
  end

  test do
    # version.to_s (scanned from the URL) keeps this correct across releases.
    assert_match version.to_s, shell_output("#{bin}/turf --version")
    assert_match version.to_s, shell_output("#{bin}/turf-mcp-server --version")
  end
end
