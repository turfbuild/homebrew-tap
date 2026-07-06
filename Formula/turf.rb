class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.2.1"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.1/turf_v0.2.1_darwin_arm64.tar.gz"
      sha256 "36691a922d7953d29ad9df4c9ad5c8f0d7b5eeb50f65f3f8aaa0b923210b96d8"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.1/turf_v0.2.1_darwin_amd64.tar.gz"
      sha256 "6ed571fcaa9e66584a06f63f36ac9c8ccb73296502fd857c6644e10d63095348"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.1/turf_v0.2.1_linux_arm64.tar.gz"
      sha256 "1b02a52296cb0055fed0383ff2255272eabce6c5c98da84dd932b458a777f58a"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.1/turf_v0.2.1_linux_amd64.tar.gz"
      sha256 "8ddfd9f50dab55540c78dac81e953bf80f397abce28a44d26687a3894b298074"
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
