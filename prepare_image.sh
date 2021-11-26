#!/bin/bash  -xeu

# Download xous-core
git clone https://github.com/betrusted-io/xous-core.git
pushd xous-core
cargo xtask
popd

# Build riscv32imac-unknown-xous toolchain
cd $(rustc --print sysroot)
wget https://github.com/betrusted-io/rust/releases/download/1.56.1.1/riscv32imac-unknown-xous_1.56.1.zip
rm -rf lib/rustlib/riscv32imac-unknown-xous-elf # Remove any existing version
unzip *.zip
rm *.zip
cd -

# Build renode-image for xous-precursor
pushd xous-core
cargo xtask renode-image
popd



