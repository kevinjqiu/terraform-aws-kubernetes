resource "aws_iam_role" "kube" {
    name = "kube"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {"Service": "ec2.amazonaws.com"},
        "Action": "sts:AssumeRole"
    }]
}
EOF
}

resource "aws_iam_role_policy" "kube" {
    name = "kube"
    role = "${aws_iam_role.kube.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {"Effect": "Allow", "Action": ["ec2:*"], "Resource": ["*"]},
        {"Effect": "Allow", "Action": ["elasticloadbalancing:*"], "Resource": ["*"]},
        {"Effect": "Allow", "Action": ["route53:*"], "Resource": ["*"]},
        {"Effect": "Allow", "Action": ["ecr:*"], "Resource": ["*"]}
    ]
}
EOF
}

resource "aws_iam_instance_profile" "kube" {
    name  = "kubernetes-instance-profile"
    roles = ["${aws_iam_role.kube.id}"]
}
