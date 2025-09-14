mkdir -p /tmp/package/thrift/
cp -r step10/thrift/* /tmp/package/thrift
cd /tmp/package/thrift
#conan source .
#conan install --build=missing .
#conan build .
conan export-pkg .
