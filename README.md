# ecsprestack-infra-example

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
                "iam:GetRolePolicy"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
```

# Related Project

- https://github.com/snaka/ecsprestack-app-example
