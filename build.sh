mkdir -p build

pushd build
cmake ..
make
popd

cp build/libheic.node .