echo "Create K8s cluster"
kind create cluster --name rmq-k8s-cluster --config "/Users/niranjansarvi/Documents/Tanzu RabbitMQ4K8s/GA/kind/k8s-3wnode.yaml"


echo "Installing pre-requisites packages"
kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/latest/download/release.yml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml

echo "create secret in a namespace"
kubectl apply -f secrete.yaml

echo "Install the Tanzu image package repository"
kapp deploy -a tanzu-rabbitmq-repo -f tanzu-rmq-repo.yaml -y

echo "create service account"
k apply -f service-account.yaml

echo "create cluster scope roles"
k apply -f cluster-role.yaml

echo "create cluster role binding"
k apply -f role-binding.yaml

echo "Install the Tanzu image package"
kapp deploy -a tanzu-rabbitmq -f tanzu-rmq-install.yaml -y

# If there is an error during this step
#kubectl get app/tanzu-rabbitmq  -o jsonpath="{.status}"

# Verify the package install
# k get packageinstall

# Delete the ClusterRole
# k delete rabbitmqcluster dev-tanzu-rabbit -n rabbitmq-system

#Create registry secret
# kubectl create secret docker-registry tanzu-registry-creds --docker-server "registry.tanzu.vmware.com" --docker-username "nsarvi@vmware.com" --docker-password 'Murthy1!@v'
# k get secret tanzu-registry-creds -n secrets-ns -o yaml
# echo -n encryptedtext | base64 --decode

# Try with Docker login and pull

# Delete the Cluster
k delete rabbitmqcluster dev-tanzu-rabbit -n rabbitmq-system

# port forward
kubectl port-forward svc/dev-tanzu-rabbit 15672:15672 -n rabbitmq-system
