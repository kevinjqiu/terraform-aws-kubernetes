bin/cfssl:
	curl -o bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
	chmod +x bin/cfssl

bin/cfssljson:
	curl -o bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
	chmod +x bin/cfssljson

gencert: bin/cfssl bin/cfssljson
	bin/cfssl gencert -initca ca-csr.json | bin/cfssljson -bare ca
