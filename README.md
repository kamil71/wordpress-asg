# Deploying VPC+ASG+ALB via Terraform on AWS

Configuration in this directory creates several different variations of resources for VPC, Autoscaling Group, Application Load Balancer.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |


To run this example you need to execute:

```bash
$ terraform init
$ terraform plan -var-file=prod.tfvars
$ terraform apply -var-file=prod.tfvars
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Resources

| Name | Type |
|------|------|
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.front_end](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="environment"></a> [environment](#environment) | Environment Type. | `string` | `Production` | yes |
| <a name="aws_region"></a> [aws\_region](#aws_region) | AWS Region| `string` | `us-east-1` | yes |
| <a name="key_name"></a> [key\_name](#key_name) | SSH key file name | `string` | `[]` | yes |
| <a name="alarms_email"></a> [alarms\_email](#alarms_email) | Emails list for SNS | `string` | `[]` | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="lb_dns_name"></a> [lb\_dns\_name](#lb\_dns_\name) | DNS Endpoint for ALB |
| <a name="public-subnet"></a> [public-subnet](#public-\subnet) | List of Public Subnets |
| <a name="private-subnet"></a> [private-subnet](#private-\subnet) | List of Private Subnets |
| <a name="vpc_id"></a> [vpc_id](#vpc_\id) | VPC ID |
| <a name="ami_value"></a> [ami_value](#ami_\value) | AMI ID |
