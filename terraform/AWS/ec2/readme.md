## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| PATH\_TO\_PRIVATE\_KEY | IAM key path | string | `"./tongshan.pem"` | no |
| PriIP | private ip list | map | `<map>` | no |
| PubIP | whether need bind public ip | string | `"true"` | no |
| ami | Zach-CentOS7.5 | string | `"ami-0666d339a1600a343"` | no |
| centos-login-info | security username | string | `"centos"` | no |
| common\_allow | ingress allow list | list | `<list>` | no |
| def-login-info | default username | string | `"root"` | no |
| dev-sg-def | dev security group | map | `<map>` | no |
| ebs | ebs volume config | map | `<map>` | no |
| env | choose env [PRD/DEV] | string | `"prd"` | no |
| key | IAM key string | string | `"tongshan"` | no |
| prd-sg-def | prd security group | map | `<map>` | no |
| region | availiable zone | string | `"cn-north-1a"` | no |
| subnet-id | subnet belong for vpc | string | `"subnet-0544b0c58ebc522e9"` | no |
| type | EC2 instance type | string | `"t2.medium"` | no |
| vpc | set prd or dev vpc id | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| EC2 type |  |
| deploy\_env |  |
| ebs |  |
| instance\_info |  |
| region |  |
| security\_group |  |

