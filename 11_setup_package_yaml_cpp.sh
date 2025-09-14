mkdir -p /tmp/package/yaml-cpp/
cp -r step11/yaml-cpp/* /tmp/package/yaml-cpp
cd /tmp/package/yaml-cpp
#conan source .
#conan install --build=missing .
#conan build .
conan export-pkg .
