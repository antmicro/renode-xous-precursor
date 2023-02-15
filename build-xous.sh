#!/usr/bin/env bash
set -xeu

# Donwload rust
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=1.67.1
source $HOME/.cargo/env

# Build riscv32imac-unknown-xous-elf toolchain
cd $(rustc --print sysroot)
wget https://github.com/betrusted-io/rust/releases/download/1.67.1.1/riscv32imac-unknown-xous_1.67.1.zip
rm -rf lib/rustlib/riscv32imac-unknown-xous-elf # Remove any existing version
unzip *.zip
rm *.zip
cd -

# Download xous-core
git clone https://github.com/betrusted-io/xous-core.git
pushd xous-core
git checkout 787525fd
git am ../patches/*

cargo xtask renode-image
popd
