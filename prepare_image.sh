#!/bin/bash  -xeu

# Build riscv32imac-unknown-xous-elf toolchain
cd $(rustc --print sysroot)
wget https://github.com/betrusted-io/rust/releases/download/1.57.0.3/riscv32imac-unknown-xous_1.57.0.zip
rm -rf lib/rustlib/riscv32imac-unknown-xous-elf # Remove any existing version
unzip *.zip
rm *.zip
cd -

# Download xous-core
git clone https://github.com/betrusted-io/xous-core.git
pushd xous-core
cargo xtask
popd

# Build renode-image for xous-precursor
pushd xous-core
cargo xtask renode-image
popd


