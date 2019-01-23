SHELL := /bin/bash

.PHONY = instances

instances: 
		terraform init 
		terraform apply -auto-approve


.PHONY = packer

packer:

		@packer build httpd.json
		@packer build nginx.json

.PHONY = terraform-init jenkins-apply

terraform-init:
		@terraform init

terraform-apply:
		@terraform apply -auto-approve
