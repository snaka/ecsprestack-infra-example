# ecsprestack-infra-example

This repository is an EXAMPLE of an infrastructure configuration for simple deployment using `ecspresso` and `ecschedule`.

Some people refer to a deployment strategy utilizing `ecspresso` + `ecschedule` as `ecsprestack`.

## Permission

The permissions required to apply this Terraform are as follows

```json
{
    "Statement": [
        {
            "Action": [
                "ec2:*",
                "elasticloadbalancing:*",
                "ecs:*",
                "logs:*",
                "iam:CreateRole",
                "iam:GetRole",
                "iam:TagRole",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:DeleteRole",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:DetachRolePolicy",
                "iam:GetRolePolicy",
                "rds:*",
                "ssm:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
```

## Variables

These variables are required to apply this Terraform.

| Name | Description |
|------|-------------|
| `db_password` | root password for DB (**must be 8 characters or more**) |
| `db_username` | Username for DB |
| `secret_key_base` | Secret key base for Rails application |

You can set these variables in `*.tfvars` file or Terraform Cloud workspace settings.

## Related Project

- https://github.com/snaka/ecsprestack-app-example
