#!/bin/sh

# Installs pinned CUDA-enabled llama.cpp binaries and their matching CUDA
# runtime libraries into ~/.local/opt. The CUDA runtime archive is required:
# NVIDIA's display driver supplies libcuda, but not libcudart or libcublas.
#
# Platforms: linux
#
# With --check, reports via exit code whether the pinned version is linked.

. "${DOTFILES:?}/lib/download.sh"

llama_ver=b11798
cuda_ver=13.4
opt="$HOME/.local/opt"
bin="$HOME/.local/bin"

case "$(uname)-$(uname -m)" in
  Linux-x86_64)
    target=x64
    bin_sha=19bc204384759d0095760c7196f132f3fbc62cb4ca3865757eed98b89d16c244
    runtime_sha=caedebcffa84f980b4563d063c146f20fbf91a1d947e5a5d26ccb365dc025668 ;;
  Linux-aarch64|Linux-arm64)
    target=arm64
    bin_sha=e0a61e6b93de65ff7ed6db1a76b7d64bef9e933bcc22cb000284225bf199864e
    runtime_sha=0aa4345384692e91d1c4c8fab35ed65bee32c9e0b7ef1f3d773a61b7fbc80aa0 ;;
  *)
    echo "Unsupported platform for llama.cpp: $(uname) $(uname -m)" >&2
    exit 1 ;;
esac

dir="$opt/llama-$llama_ver-cuda-$cuda_ver-$target"
base_url="https://github.com/ggml-org/llama.cpp/releases/download/$llama_ver"
bin_archive="llama-$llama_ver-bin-ubuntu-cuda-$cuda_ver-$target.tar.gz"
runtime_archive="cudart-llama-$llama_ver-bin-ubuntu-cuda-$cuda_ver-$target.tar.gz"

if [ "${1:-}" = --check ]; then
  test "$(readlink "$bin/llama-server")" = "$dir/llama-server" &&
  test -f "$dir/libcudart.so.13"
  exit
fi

download_verified "$base_url/$bin_archive" "$bin_sha" &&
rm -rf "$dir" && mkdir -p "$dir" "$bin" &&
tar -xzf "$downloaded" -C "$dir" --strip-components=1 &&
download_verified "$base_url/$runtime_archive" "$runtime_sha" &&
tar -xzf "$downloaded" -C "$dir" --strip-components=1 || exit 1

for executable in "$dir"/llama*; do
  test -x "$executable" || continue
  ln -sfn "$executable" "$bin/${executable##*/}"
done
