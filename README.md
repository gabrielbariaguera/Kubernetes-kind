# Orquestração de Containers com Kubernetes usando KIND, Lens e Kubernetes Dashboard

Este projeto demonstra a criação de um cluster Kubernetes local utilizando o KIND, além da instalação de ferramentas visuais como o Kubernetes Dashboard, Prometheus e Lens para visualização da orquestração de containers.

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

### 1. Clone o repositório

```bash
git clone https://github.com/gabrielbariaguera/Kubernetes-kind.git
cd kubernetes-orquestracao
```

### 2. Criação do cluster com KIND

```bash
kind create cluster --name meu-cluster --config kind-cluster.yaml
```

### 3. Acesso com Lens (opcional)

Abra o Lens e ele detectará o cluster automaticamente (para habilitar métricas vá para o passo 7).

### 4. Instalação do Kubernetes Dashboard

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f dashboard-admin.yaml
```

### 5. Geração do token

```bash
kubectl apply -f dashboard-admin.yaml
kubectl -n kubernetes-dashboard describe secret admin-user-token
```

### 6. Acesso ao Dashboard

```bash
kubectl proxy
```

Acesse: [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https\:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

### 7. Instalação do Prometheus e Grafana

```bash
chmod +x prometheus-install.sh
./prometheus-install.sh
```

## 📊 O que é um cluster Kubernetes?

Um conjunto de máquinas que executa o Kubernetes, com um control plane e nós de trabalho (workers). Ele orquestra e gerencia containers automaticamente.

## 📎 Créditos

Projeto acadêmico demonstrando orquestração de containers com Kubernetes.
