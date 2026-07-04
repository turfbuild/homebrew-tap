class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # version is scanned from the release URL.
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.0/turf_v0.2.0_darwin_arm64.tar.gz"
      sha256 "e87fb4f4dfa6c72af8aef6e5cfc86851fa8ea1522dbdb43f0f1eaa04dc1166ba"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.0/turf_v0.2.0_darwin_amd64.tar.gz"
      sha256 "035a724a95abe4cc1d3085b172d8f2e72123938c85a5dbf201c6935c1d5044d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.0/turf_v0.2.0_linux_arm64.tar.gz"
      sha256 "070237a2c1631c6ce94fcc5082eda148f5c3ed772a90b9c5731bd01742de6945"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.0/turf_v0.2.0_linux_amd64.tar.gz"
      sha256 "975595c740b57f86374476beaa80f1d25a1daf9044ca2268372af6dc11d31745"
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
