class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # version is scanned from the release URL.
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.5/turf_v0.1.0-alpha.5_darwin_arm64.tar.gz"
      sha256 "d5e722347954fe67469573248dec477a89518401d8264d7ac7ca1ece33e23c1e"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.5/turf_v0.1.0-alpha.5_darwin_amd64.tar.gz"
      sha256 "469a015e56048d406c23cdb893bf4839f23fbd3a03f85394d80ff4a69c966308"
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
    EOS
  end

  test do
    # version.to_s (scanned from the URL) keeps this correct across releases.
    assert_match version.to_s, shell_output("#{bin}/turf --version")
    assert_match version.to_s, shell_output("#{bin}/turf-mcp-server --version")
  end
end
