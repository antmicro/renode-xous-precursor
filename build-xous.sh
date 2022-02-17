#!/bin/bash  -xeu

# Donwload rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

# Build riscv32imac-unknown-xous-elf toolchain
cd $(rustc --print sysroot)
wget https://github.com/betrusted-io/rust/releases/download/1.58.1.1/riscv32imac-unknown-xous_1.58.1.zip
rm -rf lib/rustlib/riscv32imac-unknown-xous-elf # Remove any existing version
unzip *.zip
rm *.zip
cd -

# Download xous-core
git clone https://github.com/betrusted-io/xous-core.git
pushd xous-core
git checkout 317f313
git am ../patches/*

cargo xtask renode-image
popd
