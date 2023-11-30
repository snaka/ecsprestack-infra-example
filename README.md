# ecsprestack-infra-example

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
| `db_password` | Password for RDS (**must be 8 characters or more**) |
| `db_username` | Username for RDS |
| `secret_key_base` | Secret key base for Rails application |

You can set these variables in `*.tfvars` file or Terraform Cloud workspace settings.

## Related Project

- https://github.com/snaka/ecsprestack-app-example
