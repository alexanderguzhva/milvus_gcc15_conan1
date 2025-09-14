mkdir -p /tmp/package/cyrus-sasl/
cp -r step8/cyrus-sasl/* /tmp/package/cyrus-sasl
cd /tmp/package/cyrus-sasl
#conan source .
#conan install --build=missing .
#conan build .
conan export-pkg .
