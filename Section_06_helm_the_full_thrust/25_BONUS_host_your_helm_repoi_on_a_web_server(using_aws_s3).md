# Hosting charts - s3 bucket
-`aws s3 mb s3://mycharts`

- `aws s3 website s3://mycharts --index-document index.html --error-document error.html`

policy.json
{
    "Version": "2008-10-17",
    "Id": "PolicyForPublicWebsiteContant",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::mycharts/*"
        }
    ]
}


- `aws s3api put-bucket-policy --bucket mycharts --policy file:://policy.json`

- `aws s3 cp index.yaml s3://mycharts/`
- etc etc


to check if the repo was added
- `helm repo add mywebcharts <s3 link>`
- `helm repo list`