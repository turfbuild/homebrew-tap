class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.2.2"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.2/turf_v0.2.2_darwin_arm64.tar.gz"
      sha256 "0079458b9c7f82892c193a1d5ba0693fe27fc8b65bfc78b866700dc927a7a958"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.2/turf_v0.2.2_darwin_amd64.tar.gz"
      sha256 "d4c265722e2231dfb03e66919ad21aaabf0e5e1f8ef713544281af70a5075663"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.2/turf_v0.2.2_linux_arm64.tar.gz"
      sha256 "a30d85b8af9bddc190fc169ce093a1a7235b7097e088a7237736dda75432f880"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.2.2/turf_v0.2.2_linux_amd64.tar.gz"
      sha256 "f0afc7348a9be970826dca67b5421c2cb2a5ab423ee6792c034e45b06473daef"
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
