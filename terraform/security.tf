resource "aws_security_group" "kube" {
    name        = "kubernetes"
    description = "Security group for Kubernetes"
    vpc_id      = "${aws_vpc.kube.id}"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["10.240.0.0/16"]
    }

    ingress {
        from_port   = 0
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 0
        to_port     = 6443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "kubernetes"
    }
}
