class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.4.1"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.4.1/turf_v0.4.1_darwin_arm64.tar.gz"
      sha256 "4cfafde70fb740140bdfe3bf44497bdab6ee8c7656fb09bc45ad48da1bda9a88"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.4.1/turf_v0.4.1_darwin_amd64.tar.gz"
      sha256 "fd7cde465f344faffb7eb31bbb5181462fcede48bc90f405792c2e03d04e1b92"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.4.1/turf_v0.4.1_linux_arm64.tar.gz"
      sha256 "36d72cebb089c4c26981056ac7be4fbb693c84e45dd6a9c406fa2f74ed1c7e61"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.4.1/turf_v0.4.1_linux_amd64.tar.gz"
      sha256 "56c0c79986466976ade211ae0d8ba1a9b1a2bb0c32ac1557e7e2e43688163932"
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
