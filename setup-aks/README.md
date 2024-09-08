# Demonstração - Preparo do Ambiente com AKS

## Sobre

Neste guia, será utilizado o **AKS (Azure Kubernetes Service)** com a versão **1.29** do Kubernetes, rodando em **VMs compatíveis com virtualização aninhada**. Para esta apresentação, todos os comandos serão executados no **Cloud Shell** do **Azure Portal**.

## Roteiro de Preparo

### 0) Certifique-se de estar no diretório correto:

```bash
git clone https://github.com/paulnune/kubevirt-demo

cd kubevirt-demo/setup-aks
```

## Roteiro de Preparo

### 1) Criar o Resource Group

Crie o Resource Group que será utilizado para o cluster AKS:

```bash
az group create --name rg-kubervirt-demo-eastus2 --location eastus2
```

### 2) Criar o cluster Kubernetes com AKS

```bash
az aks create \
  --resource-group rg-kubervirt-demo-eastus2 \
  --name kubevirt \
  --node-count 2 \
  --enable-managed-identity \
  --generate-ssh-keys \
  --kubernetes-version 1.29.0 \
  --node-vm-size Standard_D4s_v3 \
  --vm-set-type VirtualMachineScaleSets \
  --network-plugin azure \
  --enable-addons monitoring
```

### 3) Configurar o kubectl para usar o AKS

```bash
az aks get-credentials --resource-group rg-kubervirt-demo-eastus2 --name kubevirt
kubectl get node
```

### 4) Baixar imagens do Fedora necessárias para as atividades

Crie um diretório para armazenar as imagens e faça o download das versões necessárias:

```bash
mkdir images

cd images

curl -LO http://fedora.c3sl.ufpr.br/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2

# curl -LO http://fedora.c3sl.ufpr.br/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Azure.x86_64-40-1.14.vhdfixed.xz
```

### 5) Retorne ao diretório anterior e execute o script para subir o repositório local de imagens


```bash
cd ..

./local-repo.sh

```

### 6) Instalar o operator do KubeVirt

Baixe e instale a versão mais recente do KubeVirt:

```bash
export KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | grep '"tag_name":' | awk -F'"' '{print $4}')

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml
```

### 7) Instalar o operator do CDI

O CDI (Containerized Data Importer) é necessário para gerenciar a importação de imagens de disco. Instale a versão mais recente:

```bash
export CDI_VERSION=$(curl -s https://api.github.com/repos/kubevirt/containerized-data-importer/releases/latest | grep '"tag_name":' | awk -F'"' '{print $4}')

kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-operator.yaml

kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-cr.yaml

```
### 8) Habilitar feature gates do KubeVirt

Configure as feature gates necessárias para habilitar funcionalidades avançadas do KubeVirt:

```bash
kubectl apply -f kubevirt-config.yml

```

### 9) Verificar se todos os componentes do KubeVirt estão em execução

Execute o seguinte comando para verificar o status de todos os componentes do KubeVirt no namespace correto:

```bash
kubectl get all -n kubevirt

```

Este comando exibe todos os recursos no namespace kubevirt, incluindo pods, serviços, daemonsets e deployments. Certifique-se de que todos os pods estejam em execução antes de continuar.

### 10) Instalar o CLI do KubeVirt via Krew

Instale o plugin virt do KubeVirt para gerenciar máquinas virtuais diretamente com kubectl:

```bash
kubectl krew install virt

```

Agora o CLI do KubeVirt estará disponível através do comando kubectl virt.

## Finalização

Agora que o ambiente está configurado e os operadores do KubeVirt e CDI estão instalados, você pode começar a criar e gerenciar VMs no cluster AKS.

Para mais detalhes sobre o uso, consulte a documentação oficial do [KubeVirt](https://kubevirt.io/user-guide/).
