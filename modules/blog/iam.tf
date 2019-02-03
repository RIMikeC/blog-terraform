resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": ["ec2.amazonaws.com"]
        },
        "Effect": "Allow"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  name   = "ec2_role_policy"
  role   = "${aws_iam_role.ec2_role.id}"
  policy = "${data.aws_iam_policy_document.ec2_policy_document.json}"
}

data "aws_iam_policy_document" "ec2_policy_document" {
  statement {
    actions = [
      "ec2:*",
      "s3:*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_policy" {
  name   = "ec2_policy"
  policy = "${data.aws_iam_policy_document.ec2_policy_document.json}"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name  = "ec2-${var.environment}"
  path  = "/"
  role = "${aws_iam_role.ec2_role.name}"
}
