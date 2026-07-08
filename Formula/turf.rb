class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.4.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.4.0/turf_v0.4.0_darwin_arm64.tar.gz"
      sha256 "065730908ceaa7cd107b11573acf18bff92176a0509e898453a2024ba8f2f911"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.4.0/turf_v0.4.0_darwin_amd64.tar.gz"
      sha256 "39d299abc6a8e8ceafe1c527b3834368e2e7c2747109ec486ba4d7afa570274c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.4.0/turf_v0.4.0_linux_arm64.tar.gz"
      sha256 "5c7fafd9046f86918c9c94c289e558cfc21ff635226095893d085c61b1475dd4"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.4.0/turf_v0.4.0_linux_amd64.tar.gz"
      sha256 "69e750292fe3a2f1255544472173e13f22292a2cff5b93f08ac60aa06505f9f7"
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
