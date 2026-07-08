class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.3.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.3.0/turf_v0.3.0_darwin_arm64.tar.gz"
      sha256 "7c5b36760114e2280b3baf741412ead79af643f6e3162a192639fd5a03526607"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.3.0/turf_v0.3.0_darwin_amd64.tar.gz"
      sha256 "f04ff82870a1f52e8086886f0bf351d37137df6ac7f073488eb1b7cbee447935"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.3.0/turf_v0.3.0_linux_arm64.tar.gz"
      sha256 "31ffa0a2dcda74aa1c43d90c870bd1f5f7cfebe577f4fe5484ffd755be835d9a"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.3.0/turf_v0.3.0_linux_amd64.tar.gz"
      sha256 "cf1556fdbbd58e71f18f32b78e16bc1d4fa16a54737736743c7f2993df830720"
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
