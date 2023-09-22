# TeaStore

This is a fork of the [TeaStore application](https://github.com/DescartesResearch/TeaStore) from the Descartes Research group.

In this repository, we provide automations for deploying the TeaStore application on AWS, along with a monolithic variant of the application.
We also provide [OpenTelemetry](https://opentelemetry.io/) instrumentation for the microservices and monolithic versions of the application.

Therefore, we have four new possibilities of deploying the TeaStore application:

- Microservices without OpenTelemetry
- Monolithic without OpenTelemetry
- Microservices with OpenTelemetry
- Monolithic with OpenTelemetry

We provide automation for deploying each version inside [EKS](https://aws.amazon.com/eks/) and load testing the deployed application
with [Locust](https://locust.io/) in distributed mode.

# Deploying the applications

## Creating EKS clusters in AWS

To create a kubernetes cluster on AWS to run TeaStore you just need to have the AWS cli and kubectl on your machine.

We recommend that you use AWS Cloud Shell, since the tools required for following the steps below are already configured.

First, clone the repository and run all the commands below from the root of the repository in a terminal.

1. Create the EKS clusters for the applications & locust load balancer running the command below:

   1. First we need to pick an ROLE ARN to use for the clusters.
      Run the command below command to get pick the available ROLE ARN's in your account.
      ```
      aws iam list-roles | grep Arn
      ```
2. Once we select a Role ARN to deploy the EKS clusters, simply run the command bellow to deploy
   two EKS clusters, one for TeaStore and the other one to run a Locust cluster for load generation.
   The command allow users to specify some parameters, which are the following:

   `ARN` the AWS ROLE ARN to use while deploying the resources

   `TEASTORE_INSTANCE_TYPE` the instance type for running teastore pods
   
   `TEASTORE_INSTANCES` number of instances for the Teastore cluster
   
   `LOCUST_INSTANCE_TYPE` the instance type for running locust pods
   
   `LOCUST_INSTANCES` number of instances for the Locust cluster
      
   If any of the parameters isn't specified, a default value is used instead, except for the ARN parameter.

   ```bash
   ./deploy_cluster.sh ARN=<selected arn>`
   ```
   
   Example:

   ```bash
   ./deploy_cluster.sh ARN=<selected arn> TEASTORE_INSTANCE_TYPE=t3.large LOCUST_INSTANCES=3`
   ```
   
   If any errors happen while AWS is deploying the cloudformation stack, we'll have to delete it in order to recreate it.
   To delete the failed stack, run the command  `aws cloudformation delete-stack --stack-name teastorestack` and then try the command above again.
   
2. Wait until your clusters are provisioned and working on AWS. You can check the CloudFormation page to track the progress.
   Usually this process takes around 10 to 20 minutes, so this is a good opportunity to grab a cup of tea ;)

### Deleting the resources

To delete the created resources, we simply have to delete the created cloudformation stack using the command below.

```
 aws cloudformation delete-stack --stack-name teastorestack
```


## Deploying the applications on EKS

Now that our cluster is created and running, we simply have to deploy the applications on Kubernetes.

To do that, we provide bash scripts using the appropriate manifests for each version of the application. Just run the desired
script, and it will deploy the desired version on kubernetes.

The respective scripts are:

- `deploy_teastore_monolithic.sh` for the Monolithic TeaStore without open telemetry.
- `deploy_teastore_monolithic_otel.sh` for the Monolithic TeaStore with open telemetry.
- `deploy_teastore_microservices.sh` for the Monolithic TeaStore without open telemetry.
- `deploy_teastore_microservices_otel.sh` for the Monolithic TeaStore with open telemetry.

Now we're done! We have locust and teastore running, and now we can experiment using the cluster.

## Accessing the machines

To get the machine addresses for each cluster, switch to the respective context and get the machines IP's with the command below:

`kubectl describe nodes | grep ExternalIP`

The ports for each service are already exposed to the world, thus one can simply access the services using the IP address and port of the desired service.

We're exposing as NodePorts the following ports:

## TeaStore Cluster

- 30080 (TeaStore Webui)
- 32200 (Zipkin)
- 32201 (Prometheus)
- 32202 (Loki)
- 32203 (Grafana)
- 32204 (Jaeger)

## Locust Cluster

- 32001 (Locust)

[//]: # ()
[//]: # ()
[//]: # (3. Now that the clusters are created, we can setup the applications inside Kubernetes. First, we need to authenticate with K8S.)

[//]: # ()
[//]: # (For that, we can issue the commands bellow to grab the `kubeconfig` files for both clusters.)

[//]: # ()
[//]: # (```)

[//]: # (aws eks update-kubeconfig --region <your-aws-region> --name teastore-cluster)

[//]: # (aws eks update-kubeconfig --region <your-aws-region> --name teastore-loadtester)

[//]: # (```)

[//]: # ()
[//]: # (4. List the created contexts with the `kubectl config get-contexts` command. The displayed ARN's are going to be used to select)

[//]: # (   the cluster in which we're going to deploy the applications. We'll use the teastore-cluster for running the teastore application)

[//]: # (   and the teastore-loadtester cluster for running locust.)

[//]: # ()
[//]: # (5. Activate the `teastore-cluster` context issuing the `kubectl config use-context <context name>` using the context name from the previous step.)

[//]: # ()
[//]: # (6. Deploy the Metrics Server with the [link]&#40;https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html&#41;)

[//]: # ()
[//]: # (7. Deploy OTEL infrastructure running `kubectl apply -f examples/kubernetes/otel-manifests/`)

[//]: # ()
[//]: # (8. Deploy TeaStore infrastructure running `kubectl apply -f examples/kubernetes/teastore-ribbon-otel.yaml`)

[//]: # ()
[//]: # (Now that we have TeaStore deployed, we can deploy Locust to load test our TeaStore deployment.)

[//]: # ()
[//]: # (9. Switch to the `teastore-loadtester` cluster.)

[//]: # ()
[//]: # (10. Deploy locust with the `kubectl apply -f examples/locust-kubernetes/`)

[//]: # ()
[//]: # ()
[//]: # ()
