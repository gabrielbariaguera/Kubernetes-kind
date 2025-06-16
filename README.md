# Kubernetes-kind

O Kubernetes é uma plataforma de orquestração de containers que automatiza a implantação, escalabilidade e gerenciamento de aplicações. Ele garante alta disponibilidade, balanceamento de carga e recuperação automática de falhas. Integrado ao Docker, permite rodar containers em larga escala, otimizando a eficiência operacional em nuvem ou servidores locais.

Kind (Kubernetes in Docker) é uma ferramenta para executar clusters Kubernetes locais usando “nós” em contêineres Docker. Kind foi projetado principalmente para testar o próprio Kubernetes, mas também pode ser usado para desenvolvimento local ou Integração Contínua.

## Objetivo

Demonstrar na prática o gerenciamento de containers utilizando o Kind junto ao Linux Ubuntu server 22.04.

## Requisitos

- Go versão 1.17+
- Docker
- Podman ou Nerdctl

## Instalação e utilização

1. Abra o terminal
2. Instale o Kind:
   ```
   go install sigs.k8s.io/kind@v0.29.0
   ```
3. Certifique-se o Kubernetes foi clonado no diretório `$(go env GOPATH)/src/k8s.io/kubernetes`
4. Execute o Docker
5. Com o Docker executando, crie um cluster a partir do código-fonte do Kubernetes:
   ```
    kind build node-image
    kind create cluster --image kindest/node:latest
   ```
