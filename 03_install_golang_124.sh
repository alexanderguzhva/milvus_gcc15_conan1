wget https://go.dev/dl/go1.24.7.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.24.7.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
