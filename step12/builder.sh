export PATH=/usr/local/go/bin:$PATH

LD_LIBRARY_PATH=/opt/gcc-15/lib64 \
CMAKE_POLICY_VERSION_MINIMUM=3.5 CC=/opt/gcc-15/bin/gcc CXX=/opt/gcc-15/bin/g++ make

