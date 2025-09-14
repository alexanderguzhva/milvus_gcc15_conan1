apt update && apt install -y git sudo wget build-essential mc
apt install -y python3 python3-pip
apt install -y flex bison
apt install -y build-essential git make gawk flex bison libgmp-dev libmpfr-dev libmpc-dev python3 binutils perl libisl-dev libzstd-dev tar gzip bzip2 ccache
mkdir /root/gcc15
cd /root/gcc15
wget https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-15.2.0.tar.gz
tar zxvf gcc-15.2.0.tar.gz 
cd gcc-releases-gcc-15.2.0
./contrib/download_prerequisites
mkdir /root/gcc15/build
cd /root/gcc15/build
../gcc-releases-gcc-15.2.0/configure --prefix=/opt/gcc-15 --disable-multilib --enable-languages=c,c++
make -j
make install
