```
 _____                    __                              
|_   _|__ _ __ _ __ __ _ / _| ___  _ __ _ __ ___          
  | |/ _ \ '__| '__/ _` | |_ / _ \| '__| '_ ` _ \   _____ 
  | |  __/ |  | | | (_| |  _| (_) | |  | | | | | | |_____|
  |_|\___|_|  |_|  \__,_|_|  \___/|_|  |_| |_| |_|        
                                                          
    ___        ______          
   / \ \      / / ___|         
  / _ \ \ /\ / /\___ \   _____ 
 / ___ \ V  V /  ___) | |_____|
/_/   \_\_/\_/  |____/         
                               
 _  __     _                          _            
| |/ /   _| |__   ___ _ __ _ __   ___| |_ ___  ___ 
| ' / | | | '_ \ / _ \ '__| '_ \ / _ \ __/ _ \/ __|
| . \ |_| | |_) |  __/ |  | | | |  __/ ||  __/\__ \
|_|\_\__,_|_.__/ \___|_|  |_| |_|\___|\__\___||___/
```

Terraform (+ansible) recipe for building a Kubernetes cluster on AWS according to Kelsey Hightower's [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way/) setup.

Requirements
============

* `terraform`
* `make`
* `ansible` (>2.2)

Steps to build a Kubernetes Cluster on AWS
==========================================

Generate SSH keypair to be used with the cluster
------------------------------------------------

In the root folder of the project:

    make ssh-key

Use terraform to build the infrastructure
-----------------------------------------

    cd terraform && make apply

Generate the certificates
-------------------------

    cd ansible/certs && make all

Provision the machines
----------------------

    cd ansible && make apply
