::Delete Files :: blogs-------------
::blogs - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_kubernetes\blogs\source_code
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
docker system prune -a --force

::Build image
::------------------------------
::docker build --tag blogs_docker_image .
cd D:\projects\golang_aws_terraform_jenkins\microservices_kubernetes\blogs
docker build -t k8s_ecr_public_repo_blogs .

::timeout 10
::docker run --rm -p 3000:3000 k8s_ecr_public_repo_blogs

timeout 60
::Tag image
::------------------------------
docker tag k8s_ecr_public_repo_blogs:latest public.ecr.aws/h9e6x2j6/k8s_ecr_public_repo_blogs:v3.0
:: Change versión v1.x in this file at line 31 & 40, k8s_deployment\blogs_app.yaml line 21.

::Connecting to pulic AWS ECR repo
::------------------------------
aws ecr-public get-login-password --region us-east-1 --profile dev | docker login --username AWS --password-stdin public.ecr.aws/h9e6x2j6

::Push image to public AWS ECR repo
::------------------------------
docker push public.ecr.aws/h9e6x2j6/k8s_ecr_public_repo_blogs:v3.0

::Creating .kube config file on C:\Users\Juan Manuel\.kube\config
::--------------
aws eks --region us-east-1 update-kubeconfig --name k8s_eks_cluster_kite --profile dev

::Connecting to Kubernetes cluster
::--------------
kubectl get svc

::Delete namespace
::--------------
kubectl delete namespace blogs-app-namespace

::Create namespace
::--------------
kubectl create namespace blogs-app-namespace

::Create Pods and Services
::--------------
kubectl apply -f D:\projects\golang_aws_terraform_jenkins\microservices_kubernetes\k8s_deployment\blogs_app.yaml
timeout 60

::List Pods
::--------------
kubectl get pods -n blogs-app-namespace

::List Services
::--------------
kubectl get svc -n blogs-app-namespace

::List Pod files
::--------------
::kubectl exec -it --namespace <namespace> <podname> -- bash
::kubectl exec -it --namespace blogs-app-namespace blogs-app-deployment-7fb6fbf96b-ck6wz -- bash