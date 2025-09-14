#conan download openssl/3.3.2@ -r conancenter -re
#conan download googleapis/cci.20230501@ -r conancenter -re
sudo apt install -y curl
sudo apt install -y libopenblas-openmp-dev libaio-dev pkg-config

bash -c "curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain=1.89 -y" || { echo 'rustup install failed'; exit 1;}
source $HOME/.cargo/env

sudo apt install -y curl zip unzip tar

