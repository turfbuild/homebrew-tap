class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # version is scanned from the release URL.
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.1/turf_v0.1.0-alpha.1_darwin_arm64.tar.gz"
      sha256 "dbae4dd0dd5074300c125c96c9f518280e6618ea01c8cf8cea80c7956db55595"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.1/turf_v0.1.0-alpha.1_darwin_amd64.tar.gz"
      sha256 "f61b00f8ca44bed9ff31e2c5bf6a73d58a9252f2726b17684f777b349026d5bb"
    end
  end

  def install
    # Install both binaries: the CLI shells out to turf-mcp-server via PATH.
    bin.install "turf", "turf-mcp-server"
    # Keep the evaluation license and third-party notices with the install.
    prefix.install "LICENSE", "NOTICE"
    doc.install "README.md"
  end

  test do
    assert_match "v0.1.0-alpha.1", shell_output("#{bin}/turf --version")
    assert_match "v0.1.0-alpha.1", shell_output("#{bin}/turf-mcp-server --version")
  end
end
