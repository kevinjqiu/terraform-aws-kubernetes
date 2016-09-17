resource "aws_instance" "etcd" {
    ami                         = "${var.amis["etcd"]}"
    key_name                    = "kubernetes"
    vpc_security_group_ids      = ["${aws_security_group.kube.id}"]
    instance_type               = "t2.small"
    subnet_id                   = "${aws_subnet.kube.id}"
    associate_public_ip_address = "true"
    count                       = 3
    source_dest_check           = "true"
    iam_instance_profile        = "${aws_iam_instance_profile.kube.id}"
    tags {
        Name = "kubernetes-etcd-${count.index}"
    }
    provisioner "file" {
        source      = "certs/"
        destination = "/home/ubuntu"
        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = "${file("keys/id_rsa")}"
        }
    }
}

resource "aws_instance" "kube_controller" {
    ami                         = "${var.amis["kube_controller"]}"
    key_name                    = "kubernetes"
    instance_type               = "t2.small"
    vpc_security_group_ids      = ["${aws_security_group.kube.id}"]
    subnet_id                   = "${aws_subnet.kube.id}"
    associate_public_ip_address = "true"
    count                       = 3
    source_dest_check           = "true"
    iam_instance_profile        = "${aws_iam_instance_profile.kube.id}"
    tags {
        Name = "kubernetes-controller-${count.index}"
    }
    provisioner "file" {
        source      = "certs/"
        destination = "/home/ubuntu"
        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = "${file("keys/id_rsa")}"
        }
    }
}

resource "aws_instance" "kube_worker" {
    ami                         = "${var.amis["kube_worker"]}"
    key_name                    = "kubernetes"
    instance_type               = "t2.small"
    vpc_security_group_ids      = ["${aws_security_group.kube.id}"]
    subnet_id                   = "${aws_subnet.kube.id}"
    associate_public_ip_address = "true"
    count                       = 3
    source_dest_check           = "true"
    iam_instance_profile        = "${aws_iam_instance_profile.kube.id}"
    tags {
        Name = "kubernetes-worker-${count.index}"
    }
    provisioner "file" {
        source      = "certs/"
        destination = "/home/ubuntu"
        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = "${file("keys/id_rsa")}"
        }
    }
}
