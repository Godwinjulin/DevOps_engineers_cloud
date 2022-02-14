resource "aws_iam_user" "useradmin" {
  name          = "useradmin"
  path          = "/useradmin/"
  force_destroy = true
  tags = {
    tag-key = "common"
  }
}

resource "aws_iam_access_key" "useradmin" {
  user = aws_iam_user.useradmin.name
}

resource "aws_iam_user_policy" "useradmin" {
  name = "userpolicy"
  user = aws_iam_user.useradmin.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_login_profile" "useradmin_login" {
  user                    = aws_iam_user.useradmin.name
  pgp_key                 = "keybase:cloudformation"
  password_length         = 10
  password_reset_required = true
}

resource "aws_iam_user_ssh_key" "useradmin" {
  username   = aws_iam_user.useradmin.name
  encoding   = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvs2mdNAdNmsHoxKxlYd8ByvCe/XnywFdczyIXVAW4YP8iCoiCwAmtgA6FO7SoETRMbU7u6tmMhRERLIpS/6uTI5HMNucKpe1/1FGeeQ2vMnqGH1zA2DsdXd0xfGB0ibpnNd14B87nJdRUtmDMTSgC3DVYunVsjAYOl6F5/Gr701053mv2AqbwyBR/oJrI09yGNVUeFwXNLzIuPqmgtnoILt1uF+kwFMVVed25lEEt/DcvdDkmhbUxVBPwQhGH9RxTKz5eXT/Sd+37j1FZwpvFENq8nqKG3spASVePO2Tf6kMDlutFVW/nIqKJu91jwr4/KYMBJTTcRng8BHE0FGswKMCTnPlvPYqQvt1QuflEpXbv7Aj417TU8MR9d5lUCw/et+dVBfcjFEuJCK8AFZ2jvOuj2FoQjeOGPFAaFnYsHYiMNEMWhi+f21po0d1oz99SPl+nakwOkrKZNOLfJXuhf49gw2JOdtr20oBiTHElG9uUbBAl53s1+AL/Q98KTos= Laptop@Nick-devops"
}

resource "aws_iam_role" "user_role" {
  name = "dev"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "test"
  }
}

resource "aws_iam_group" "useradmingroup" {
  name = "develop"
  path = "/usersx/"
}

resource "aws_iam_policy" "useradmingroup-policy" {
  name        = "test2x"
  path        = "/system/"
  description = "useradmingroup policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "user-role-attach" {
  name       = "user-role-attachment"
  users      = [aws_iam_user.useradmin.name]
  roles      = [aws_iam_role.user_role.name]
  groups     = [aws_iam_group.useradmingroup.name]
  policy_arn = aws_iam_policy.useradmingroup-policy.arn
}