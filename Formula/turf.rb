class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.6.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.6.0/turf_v0.6.0_darwin_arm64.tar.gz"
      sha256 "72bd1a38f58cbf7de4cdfc05591bccc2a60607665353b8b76c9bd49631579961"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.6.0/turf_v0.6.0_darwin_amd64.tar.gz"
      sha256 "2be468341c1e94103f1d967829d3e206646595f81bfa533b3186df1c0d42351d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.6.0/turf_v0.6.0_linux_arm64.tar.gz"
      sha256 "35a2b86df6167d6bb07264dc82604bc44d23637058342fa1da52ce9a227a6d33"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.6.0/turf_v0.6.0_linux_amd64.tar.gz"
      sha256 "93b75a207e01a38ceec90f162826571fb80423c1e3cd6ca25a0dbdc005e1a6cb"
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
