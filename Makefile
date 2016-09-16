rekey:
	ssh-keygen -f keys/id_rsa

plan:
	terraform plan

apply:
	terraform apply

v:
	terraform validate
