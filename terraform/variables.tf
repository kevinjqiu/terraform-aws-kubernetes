variable "access_key" {
    description = "AWS access key"
}

variable "secret_key" {
    description = "AWS secret access key"
}

variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "amis" {
    description = "AMIs for instances"
    default = {
        etcd            = "ami-2ef48339"
        kube_controller = "ami-2ef48339"
        kube_worker     = "ami-2ef48339"
    }
}
