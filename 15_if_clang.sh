# install llvm-21
cd /tmp
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 21

# install openmp for clang-21
sudo apt install -y libomp-21-dev

# setup conan
mkdir -p ~/.conan/profiles
cp step15/default ~/.conan/profiles
cp step15/settings.yml ~/.conan

# this is needed for `pkgconfig` package, bcz it will look for `clang` and `clang++` precisely, ignoring $CC and $CXX
cd /usr/bin
sudo ln -s clang++-21 clang++
sudo ln -s clang-21 clang 
