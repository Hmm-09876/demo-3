FUNC := demo_lambda
BUCKET := demo-terraform-bucket
FILETXT := ./tests/test.txt

.PHONY: lambda-invoke lambda-logs s3-upload evidence lambda-update tf-plan lambda-config s3-notify

lambda-invoke:
	awslocal lambda invoke --function-name $(FUNC) --payload '$(PAYLOAD)' response.json && cat response.json

lambda-logs:
	awslocal logs filter-log-events --log-group-name /aws/lambda/$(FUNC) --limit 50

s3-upload:
	awslocal s3 cp $(FILETXT) s3://$(BUCKET)/$(KEY)

evidence:
	mkdir -p evidence
	awslocal lambda list-functions > evidence/lambda-list.json || true
	awslocal lambda invoke --function-name $(FUNC) --payload '{"test": "evidence"}' evidence/lambda-invoke.json || true
	awslocal logs filter-log-events --log-group-name /aws/lambda/$(FUNC) > evidence/lambda-logs.json || true
	awslocal s3 ls s3://$(BUCKET)/ > evidence/s3-ls.txt || true
	tflocal show -json tfplan | jq . > evidence/tf-plan.json || true
	tflocal show > evidence/tf-show.txt

lambda-update:
	awslocal lambda update-function-code --function-name $(FUNC) --zip-file fileb://function.zip

tf-plan:
	tflocal init
	tflocal plan -out=tfplan || true
	tflocal show -json tfplan | jq . > evidence/tf-plan.json

lambda-config:
	awslocal lambda get-function-configuration --function-name $(FUNC)

s3-notify:
	awslocal lambda remove-permission --function-name $(FUNC) --statement-id s3invoke || true
	awslocal lambda add-permission --function-name $(FUNC) --statement-id s3invoke --action "lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn arn:aws:s3:::$(BUCKET) || true
	awslocal s3api put-bucket-notification-configuration --bucket $(BUCKET) --notification-configuration file://notif.json