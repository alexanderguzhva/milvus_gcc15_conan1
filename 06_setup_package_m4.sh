mkdir -p /tmp/package/m4/
cp -r step6/m4/* /tmp/package/m4
cd /tmp/package/m4
conan source .
conan install .
conan build .
conan export-pkg .
