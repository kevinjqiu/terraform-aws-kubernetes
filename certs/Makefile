bin/cfssl:
	curl -o bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
	chmod +x bin/cfssl

bin/cfssljson:
	curl -o bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
	chmod +x bin/cfssljson

ca.pem: bin/cfssl bin/cfssljson
	bin/cfssl gencert -initca ca-csr.json | bin/cfssljson -bare ca
	openssl x509 -in ca.pem -text -noout

kubernetes-csr.json:
	cat kubernetes-csr.json.tmpl | sed 's/HOSTS/$(shell cd ../terraform && make ips)/' > kubernetes-csr.json

kubernetes.pem: bin/cfssl bin/cfssljson ca.pem kubernetes-csr.json
	bin/cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=ca-config.json \
		-profile=kubernetes \
		kubernetes-csr.json | bin/cfssljson -bare kubernetes
	openssl x509 -in kubernetes.pem -text -noout

clean-ca:
	rm ca.pem ca-key.pem ca.csr

clean-kubernetes:
	rm kubernetes-csr.json
