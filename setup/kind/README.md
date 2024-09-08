# Demonstração - Preparo do Ambiente

## Sobre

Espera-se que os seguintes componentes já estejam devidamente instalados e configurados na máquina de demonstração:

- [Docker Engine CE v19.03.12+](https://docs.docker.com/get-docker/)
- [Kind v0.8.1+](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Kubernetes CLI (kubectl) v1.18+](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Kubernetes Krew v0.3.4+](https://krew.sigs.k8s.io/docs/user-guide/setup/install/)

Na apresentação, foi utilizado um **Dell Inc. Latitude 7490** com **Fedora Workstation 40**, mas a demonstração funcionará com:

- **SO:** Ubuntu/Fedora/Debian/CentOS/RHEL
- **CPU:** 2GHz+ com 2 cores
- **RAM:** 8GB
- **HDD:** 20GB livres.

## Roteiro de Preparo

### 0) Verificar diretório correto

Certifique-se de estar no diretório correto:

```bash
git clone https://github.com/paulnune/kubevirt-demo

cd kubevirt-demo/setup-kind
```
### 1) Validar capacidade de virtualização assistida aninhada

Verifique se a sua máquina suporta virtualização assistida aninhada:

```bash
cat /sys/module/kvm_intel/parameters/nested

```

O retorno esperado é Y.

### 2) Baixar imagens do Fedora necessárias para as atividades

Crie um diretório para armazenar as imagens e faça o download das versões necessárias:

```bash
mkdir images

cd images

curl -LO http://fedora.c3sl.ufpr.br/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2

```

### 3) Retorne ao diretório anterior e execute o script para subir o repositório local de imagens


```bash
cd ..

./local-repo.sh

```

### 4) Criar um cluster Kubernetes local com Kind

Crie o cluster Kubernetes local com 1 control-plane e 1 worker node. No exemplo abaixo, estou usando a versão 1.29.8, mas você pode ajustar conforme necessário:

```bash
kind create cluster --config kind-config.yml

```

### 5) Instalar o operator do KubeVirt

Baixe e instale a versão mais recente do KubeVirt:

```bash
export KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | grep '"tag_name":' | awk -F'"' '{print $4}')

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml
```

### 6) Instalar o operator do CDI

O CDI (Containerized Data Importer) é necessário para gerenciar a importação de imagens de disco. Instale a versão mais recente:

```bash
export CDI_VERSION=$(curl -s https://api.github.com/repos/kubevirt/containerized-data-importer/releases/latest | grep '"tag_name":' | awk -F'"' '{print $4}')

kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-operator.yaml

kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-cr.yaml

```
### 7) Habilitar feature gates do KubeVirt

Configure as feature gates necessárias para habilitar funcionalidades avançadas do KubeVirt:

```bash
kubectl apply -f kubevirt-config.yml

```

### 8) Verificar se todos os componentes do KubeVirt estão em execução

Execute o seguinte comando para verificar o status de todos os componentes do KubeVirt no namespace correto:

```bash
kubectl get all -n kubevirt

```

Este comando exibe todos os recursos no namespace kubevirt, incluindo pods, serviços, daemonsets e deployments. Certifique-se de que todos os pods estejam em execução antes de continuar.

### 9) Instalar o CLI do KubeVirt via Krew

Instale o plugin virt do KubeVirt para gerenciar máquinas virtuais diretamente com kubectl:

```bash
kubectl krew install virt

```

Agora o CLI do KubeVirt estará disponível através do comando kubectl virt.

## Finalização

Agora que o ambiente está configurado e os operadores do KubeVirt e CDI estão instalados, você pode começar a criar e gerenciar VMs no cluster Kubernetes local.

Para mais detalhes sobre o uso, consulte a documentação oficial do [KubeVirt](https://kubevirt.io/user-guide/).
