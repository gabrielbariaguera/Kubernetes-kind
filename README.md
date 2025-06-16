# Orquestração de Containers com Kubernetes usando KIND, Lens e Kubernetes Dashboard

Este projeto demonstra a criação de um cluster Kubernetes local utilizando o KIND, além da instalação de ferramentas visuais como o Kubernetes Dashboard, Prometheus e Lens para visualização da orquestração de containers.


## 📊 O que é um cluster Kubernetes?

Um conjunto de máquinas que executa o Kubernetes, com um control plane e nós de trabalho (workers). Ele orquestra e gerencia containers automaticamente.



## 🔧 Tecnologias utilizadas

* Kubernetes
* KIND (Kubernetes IN Docker)
* Lens
* Kubernetes Dashboard
* Prometheus + Grafana

## 📦 Pré-requisitos e Instalação

### Fedora

```bash
sudo dnf install docker kubectl git -y

# Instalar KIND
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64"
sudo mv ./kind /usr/local/bin/kind
chmod +x /usr/local/bin/kind

# Ativar o Docker
sudo systemctl start docker
sudo systemctl enable docker
```

### Ubuntu/Debian

```bash
sudo apt update && sudo apt install -y docker.io kubectl git curl

# Instalar KIND
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64"
sudo mv ./kind /usr/local/bin/kind
chmod +x /usr/local/bin/kind

# Ativar o Docker
sudo systemctl start docker
sudo systemctl enable docker
```

## 🚀 Passo a passo

## 1. Clone o repositório

```bash
git clone https://github.com/gabrielbariaguera/Kubernetes-kind.git
cd kubernetes-orquestracao
```

## 2. Criação do cluster com KIND

```bash
kind create cluster --name meu-cluster --config kind-cluster.yaml
```

## 3. Acesso com Lens (opcional)

Abra o Lens e ele detectará o cluster automaticamente (para habilitar métricas vá para o passo 8).

## 4. Instalação do Kubernetes Dashboard

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f dashboard-admin.yaml
```

## 5. Criação de Usuário e Geração do token

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
```

criar um token para o acesso ao dashboard:
```bash
kubectl -n kubernetes-dashboard create token admin-user
```

## 6. Usando o Port-Foward para o acesso ao Dashboard

```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard 8443:443
```

Acesse: [https://localhost:8443](https://localhost:8443)


## 7. Criando um Serviço Nginx Básico para vizualização de Pods (duas cópias idênticas)

criar um deployment:
```bash
kubectl create deployment nginx-dashboard --image=nginx:alpine --replicas=2
```

expor o deployment como serviço:
```bash
kubectl expose deployment nginx-dashboard --port=80 --type=NodePort
```

verificar os pods criados:
```bash
kubectl get pods -l app=nginx-dashboard -o wide
```

## 8. Exemplos de Orquestração do Kubernetes:

### 8.1 Escalabilidade:

Escalabilidade: criando réplicas dos Pods já existentes
```bash
kubectl scale deployment nginx-dashboard --replicas=5
```
Utilize para ver atualizações em tempo real:
```bash
watch -n 1 kubectl get pods
```
#### O Kubernetes permite a escalabilidade em tempo real

### 8.2 Exemplo de Auto-Recuperação:

Liste todos os Pods:
```bash
kubectl get pods
```
Escolha um e, de maneira forçada, remova-o:
```bash
kubectl delete pod <POD-ESCOLHIDO> --force
```
#### O Kubernetes automaticamente cria um novo Pod para substituir o deletado/com erro

### 8.3 Rollback

Verifique o histórico de atualizações:
```bash
kubectl rollout history deployment/nginx-dashboard
```

Volte uma versão anterior, é como dar um "CTRL Z" na sua aplicação!
```bash
kubectl rollout undo deployment/nginx-dashboard
```

Ou até mesmo específique uma versão específica (voltando a versão 1):
```bash
kubectl rollout undo deployment/nginx-dashboard --to-revision=1
```
#### O Kubernetes consegue fazer essas trocas de versões sem interromper a aplicação!

Atualizando a imagem para uma versão inexistente para simular erros:
```bash
kubectl set image deployment/nginx-dashboard nginx=nginx:versao-inexistente
```

Dê uma olhada nos pods falhando, e então volte para a versão anterior e o Kubernetes consegue recuperá-los automaticamente:
```bash
watch kubectl get pods
```

## 9. Instalação do Prometheus e Grafana (opcional)

```bash
chmod +x prometheus-install.sh
./prometheus-install.sh
```


## 📎 Créditos

Projeto acadêmico demonstrando orquestração de containers com Kubernetes.