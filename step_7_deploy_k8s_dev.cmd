::Delete Files :: Ping-------------
::Ping - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_kubernetes\ping\source_code
del main
del main.exe
del *.exe
del *.exe~

::Compiling binaries to upload to Docker (localhost) -> AWS ECR -> AWS EKS (K8s)
::------------------------------
set GOOS=linux
set CGO_ENABLED=0
go build main.go

::Remove old images
::------------------------------
docker image rm k8s_ecr_public_repo_ping
docker image rm public.ecr.aws/h9e6x2j6/k8s_ecr_public_repo_ping

::Build image
::------------------------------
::docker build --tag ping_docker_image .
docker build -t k8s_ecr_public_repo_ping .

::Tag image
::------------------------------
::docker tag ping_docker_image:latest public.ecr.aws/h9e6x2j6/docker_ping_repo_pub:1
docker tag k8s_ecr_public_repo_ping:latest public.ecr.aws/h9e6x2j6/k8s_ecr_public_repo_ping:latest

::Connecting to pulic AWS ECR repo
::------------------------------
::aws ecr-public get-login-password --region us-east-1 --profile dev | docker login --username AWS --password-stdin public.ecr.aws/h9e6x2j6/docker_ping_repo_pub
aws ecr-public get-login-password --region us-east-1 --profile dev | docker login --username AWS --password-stdin public.ecr.aws/h9e6x2j6

::Delete image to public AWS ECR repo
::------------------------------
::aws ecr batch-get-image --repository-name k8s_ecr_public_repo_ping --image-ids imageTag=latest --region us-east-1
::aws ecr batch-delete-image --repository-name k8s_ecr_public_repo_ping --image-ids imageTag=latest --region us-east-1

::Push image to public AWS ECR repo
::------------------------------
::docker push public.ecr.aws/h9e6x2j6/docker_ping_repo_pub:1
docker push public.ecr.aws/h9e6x2j6/k8s_ecr_public_repo_ping:latest

::Creating .kube config file on C:\Users\Juan Manuel\.kube\config
::--------------
aws eks --region us-east-1 update-kubeconfig --name k8s_eks_cluster_kite --profile dev

::Connecting to Kubernetes cluster
::--------------
kubectl get svc

::Delete namespace
::--------------
kubectl delete namespace ping-app-namespace

::Create namespace
::--------------
kubectl create namespace ping-app-namespace

::Create Pods and Services
::--------------
kubectl apply -f D:\projects\golang_aws_terraform_jenkins\microservices_kubernetes\k8s_deployment\ping_app.yaml

::List Pods
::--------------
kubectl get pods -n ping-app-namespace

::List Services
::--------------
kubectl get svc -n ping-app-namespace

