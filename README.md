# Orquestração de Containers com Kubernetes usando KIND, Lens e Kubernetes Dashboard

Este projeto demonstra a criação de um cluster Kubernetes local utilizando o KIND, além da instalação de ferramentas visuais como o Kubernetes Dashboard, Prometheus e Lens para visualização da orquestração de containers.


## 🎯 Objetivo do Kubernetes
O Kubernetes (K8s) é um **orquestrador de containers** projetado para:
- **Automatizar** a implantação, escalonamento e gerenciamento de aplicações em containers
- Garantir **alta disponibilidade** (zero downtime)
- Gerenciar **recursos de forma eficiente** (CPU, memória, armazenamento)
- Facilitar **descoberta de serviços** e balanceamento de carga
- Permitir **atualizações contínuas** e rollback automático

Problemas que ele resolve:
- Containers que falharem são reiniciados automaticamente
- Escalonamento rápido de aplicações para evitar sobrecarga
- Atualizações são aplicadas sem causarem o "Downtime"


## 🔧 Tecnologias utilizadas

* Kubernetes
* KIND (Kubernetes IN Docker)
* Lens
* Kubernetes Dashboard


## 📊 O que é um Cluster Kubernetes?
Um conjunto de máquinas (físicas ou virtuais) que executa o Kubernetes, composto por:
- **Control Plane**: "Cérebro" do cluster (toma decisões de orquestração)
- **Nodes (workers)**: Máquinas que executam os containers
- **Pods**: Unidade mínima de deploy (é como um pacote de containers)

## 🌐 Arquitetura Básica de um Cluster Kubernetes
```markdown
[Control Plane]
├── API Server
├── Scheduler
├── Controller Manager
├── etcd (armazenamento)
└── [Worker Nodes]
├── Kubelet
├── Kube-Proxy
└── Pods (seus containers)
```

## 📦 Pré-requisitos e Instalação


### Ubuntu/Debian

```markdown
sudo apt update && sudo apt install -y docker.io kubectl git curl

# Instalar KIND
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64"
sudo mv ./kind /usr/local/bin/kind
chmod +x /usr/local/bin/kind

# Ativar o Docker
sudo systemctl start docker
sudo systemctl enable docker
```

### Fedora

```markdown
sudo dnf install docker kubectl git -y

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

```markdown
git clone https://github.com/gabrielbariaguera/Kubernetes-kind.git
cd kubernetes-orquestracao
```

## 2. Acesso com Lens - Interface Gráfica (opcional)
### 2.1 Torne o script executável:
```markdown
chmod +x lens-install.sh
```
### 2.2 Execute o script:
```markdown
./lens-install.sh
```
Após a instalação execute o Lens.

## 3. Criação do cluster com KIND

```markdown
kind create cluster --name meu-cluster --config kind-config.yaml
```
Abra o Lens e ele detectará o cluster automaticamente (para habilitar métricas vá para o passo 8).

## 4. Instalação do Kubernetes Dashboard - Interface Gráfica (obrigatória)

```markdown
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f dashboard-admin.yaml
```

## 5. Criação de Usuário e Geração do token

```markdown
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
```markdown
kubectl -n kubernetes-dashboard create token admin-user
```

## 6. Usando o Port-Foward para o acesso ao Dashboard

```markdown
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard 8443:443
```

Acesse: [https://localhost:8443](https://localhost:8443)


## 7. Criando um Deployment Nginx para Demonstração de Pods (duas cópias idênticas)
No Kubernetes, containers são encapsulados em **Pods** (a menor unidade deployável).

Vamos criar um deployment:
```markdown
kubectl create deployment nginx-dashboard --image=nginx:alpine --replicas=2
```

Expor o deployment como serviço:
```markdown
kubectl expose deployment nginx-dashboard --port=80 --type=NodePort
```

Verificar os pods criados:
```markdown
kubectl get pods -l app=nginx-dashboard -o wide
```
Os Nodes são máquinas virtuais (VMs) que fazem parte do cluster do Kubernetes, é como se fosse o servidor que deixa os Pods no ar

**Para visualizar containers dentro de um Pod use:**
```markdown
kubectl describe pod NOME-DO-POD | grep -A 5 "Containers:"
```

## 8. Exemplos de Orquestração do Kubernetes:

### 8.1 Escalabilidade:

Escalabilidade: criando réplicas dos Pods já existentes
```markdown
kubectl scale deployment nginx-dashboard --replicas=5
```
Utilize para ver atualizações em tempo real:
```markdown
watch -n 1 kubectl get pods
```
#### O Kubernetes permite a escalabilidade em tempo real sem Downtime

### 8.2 Exemplo de Auto-Recuperação:

Liste todos os Pods:
```markdown
kubectl get pods
```
Escolha um e, de maneira forçada, remova-o:
```markdown
kubectl delete pod <POD-ESCOLHIDO> --force
```
#### O Kubernetes automaticamente cria um novo Pod para substituir o deletado/com erro

### 8.3 Rollback

Verifique o histórico de atualizações:
```markdown
kubectl rollout history deployment/nginx-dashboard
```

Volte uma versão anterior, é como dar um "CTRL Z" na sua aplicação!
```markdown
kubectl rollout undo deployment/nginx-dashboard
```

Ou até mesmo específique uma versão específica (voltando a versão 1):
```markdown
kubectl rollout undo deployment/nginx-dashboard --to-revision=1
```
#### O Kubernetes consegue fazer essas trocas de versões sem interromper a aplicação!

Atualizando a imagem para uma versão inexistente para simular erros:
```markdown
kubectl set image deployment/nginx-dashboard nginx=nginx:versao-inexistente
```

Dê uma olhada nos pods falhando, e então volte para a versão anterior e o Kubernetes consegue recuperá-los automaticamente:
```markdown
watch kubectl get pods
```

## 📎 Referências

[Documentação Kubernetes](https://kubernetes.io/docs/home/)<br>
[Documentação Kind](https://kind.sigs.k8s.io/docs/)<br>
[Documentação Docker](https://docs.docker.com/)
