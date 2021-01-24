



aws elb create-load-balancer --load-balancer-name test_load_balancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets ubnet-30f6a97d --security-groups sg-0c239e75ab72bb619
aws elb register-instances-with-load-balancer --load-balancer-name testloadbalancer --instances file://instances_to_add.json