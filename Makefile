zombie-cleaner-%-init:
	cd environments/$* && terraform	 init
zombie-cleaner-%-plan:
	cd environments/$* && terraform plan
zombie-cleaner-%-apply:
	# cd modules/compute/lambda/layers/package/nodejs/ && npm i --omit=dev
	cd environments/$* && terraform apply --auto-approve
zombie-cleaner-%-destroy:
	cd environments/$* && terraform destroy