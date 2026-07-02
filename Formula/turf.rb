class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # version is scanned from the release URL.
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.6/turf_v0.1.0-alpha.6_darwin_arm64.tar.gz"
      sha256 "105bc0ad8aca9af1fba3beaa3b21b031e17fce1bdd3b130ce60663a319ce18dd"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.6/turf_v0.1.0-alpha.6_darwin_amd64.tar.gz"
      sha256 "994ed407b4bfa68e9aaca4ac2bf2d019fba4e82df819851bd05f82b56266d0f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.6/turf_v0.1.0-alpha.6_linux_arm64.tar.gz"
      sha256 "6cf8ec3865c1927b94f0b1890fd4c93e13f776995b4947f25189ab9e3a96d9e2"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.1.0-alpha.6/turf_v0.1.0-alpha.6_linux_amd64.tar.gz"
      sha256 "a2e782a1a7482a22b37319b924e9cfbe4a149df3fc042b351e4623fb2d2ac053"
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
