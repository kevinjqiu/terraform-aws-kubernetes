resource "aws_vpc_dhcp_options" "kube" {
    domain_name = "${var.region}.compute.internal"
    domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc" "kube" {
    cidr_block           =  "10.240.0.0/16"
    enable_dns_support   = "true"
    enable_dns_hostnames = "true"

    tags {
        Name = "kubernetes"
    }
}

resource "aws_vpc_dhcp_options_association" "kube" {
    vpc_id = "${aws_vpc.kube.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.kube.id}"
}

resource "aws_subnet" "kube" {
    vpc_id     = "${aws_vpc.kube.id}"
    cidr_block = "10.240.0.0/24"
    tags {
        Name = "kubernetes"
    }
}

resource "aws_internet_gateway" "kube" {
    vpc_id = "${aws_vpc.kube.id}"
    tags {
        Name = "kubernetes"
    }
}

resource "aws_route_table" "kube" {
    vpc_id = "${aws_vpc.kube.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.kube.id}"
    }
}

resource "aws_route_table_association" "kube" {
    subnet_id      = "${aws_subnet.kube.id}"
    route_table_id = "${aws_route_table.kube.id}"
}
