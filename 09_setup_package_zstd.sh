mkdir -p /tmp/package/zstd/
cp -r step9/zstd/* /tmp/package/zstd
cd /tmp/package/zstd
#conan source .
#conan install --build=missing .
#conan build .
conan export-pkg .
