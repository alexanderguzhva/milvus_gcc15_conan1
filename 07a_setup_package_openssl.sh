mkdir -p /tmp/package/openssl/
cp -r step7a/openssl/* /tmp/package/openssl
cd /tmp/package/openssl
#conan source .
#conan install --build=missing .
#conan build .
conan export-pkg .
