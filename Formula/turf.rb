class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # version is scanned from the release URL.
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.3/turf_v0.1.0-alpha.3_darwin_arm64.tar.gz"
      sha256 "c7b0e8bd318a2fc98ffb37cf2202f2a15f1af3bb338556ba6cd3f325a5a3e10c"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.3/turf_v0.1.0-alpha.3_darwin_amd64.tar.gz"
      sha256 "a3363321480cea238dc63223b5fd03f1b0f4454d58448aae2031ff5a316f45ed"
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
