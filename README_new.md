# Getting started

## Deploy on AWS with OpenTelemetry

To create a kubernetes cluster on AWS to run TeaStore you just need to have the AWS cli and kubectl on your machine.

1. Create the EKS clusters for the applications & locust load balancer

    1. First we need to pick an ROLE ARN to use for the clusters. 
        Run the command below command to get pick the available ROLE ARN's in your account.
        ```
       aws iam list-roles | grep Arn
       ```
    2. Check the subnets ids in your account with the command below and pick the subnets that you want to use for your cluster.
        ```
       aws ec2 describe-subnets 
       ```
    3. Once you have the subnet ids and the Role ARN to deploy the EKS clusters, simply run the command bellow to deploy
   two EKS clusters, one for TeaStore and the other one to run a Locust cluster for load generation.

```
       aws cloudformation create-stack --stack-name teastorestack --template-body file://cloudformation.yml \\
       --parameters ParameterKey=ClustersARN,ParameterValue=<ARN> \\
       ParameterKey=ClustersSubnetIds,ParameterValue=<subnet1>\\,subnet2\\,subnet3
```

        Example:
        ```
        aws cloudformation create-stack --stack-name teastorestack --template-body file://cloudformation.yml \\
        --parameters ParameterKey=ClustersARN,ParameterValue=arn:aws:iam::594411245622:role/LabRole \\
        ParameterKey=ClustersSubnetIds,ParameterValue=subnet-046503977e6ef5a5b\\,subnet-06e0b229c77329004\\,subnet-0b0e0e4bd8cb00937\\,subnet-0e0c19a63f9406020
        ```

    PS: Note that the SubnetIds must be separated by a comma, however we need to escape the comma, thus we need to write `<subnetid>\\,<other subnet id>` to escape things properly.

2. Wait until your clusters are provisioned and working on AWS. You can check the CloudFormation page to track the progress.

3. Now that the clusters are created, we can setup the applications inside Kubernetes. First, we need to authenticate with K8S.

For that, we can issue the commands bellow to grab the `kubeconfig` files for both clusters.

```
aws eks update-kubeconfig --region <your-aws-region> --name teastore-cluster
aws eks update-kubeconfig --region <your-aws-region> --name teastore-loadtester
```

4. List the created contexts with the `kubectl config get-contexts` command. The displayed ARN's are going to be used to select
the cluster in which we're going to deploy the applications. We'll use the teastore-cluster for running the teastore application
and the teastore-loadtester cluster for running locust.

5. Activate the `teastore-cluster` context issuing the `kubectl config use-context <context name>` using the context name from the previous step.

6. Deploy OTEL infrastructure running `kubectl apply -f examples/kubernetes/otel-manifests/`

7. Deploy TeaStore infrastructure running `kubectl apply -f examples/kubernetes/teastore-ribbon-otel.yaml`

Now that we have TeaStore deployed, we can deploy Locust to load test our TeaStore deployment.

8. Switch to the `teastore-loadtester` cluster.

9. Deploy locust with the `kubectl apply -f examples/locust-kubernetes/`

Now we're done! We have locust and teastore running and now we can experiment using the cluster.

## Accessing the machines

To allow accessing the machines, we have to free the ports inside the security groups. 

To get the machine addresses for each cluster, switch to the respective context and get the machines IP's with the command below:

`kubectl describe nodes | grep ExternalIP`

We're exposing as NodePorts the following ports:

## TeaStore Cluster

- 32008 (TeaStore Webui)
- 32200 (Zipkin)
- 32201 (Prometheus)
- 32202 (Loki)
- 32203 (Grafana)
- 32204 (Jaeger)

## Locust Cluster

- 32001 (Locust)

## Deleting the resources

To delete the created resources, we simply have to delete the created cloudformation stack using the command below.

```
 aws cloudformation delete-stack --stack-name teastorestack
```