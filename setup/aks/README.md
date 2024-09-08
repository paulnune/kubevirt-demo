# Demonstração - Preparo do Ambiente com AKS

## Sobre

Para esta demonstração, será utilizado o **Azure CLI** no terminal do **Fedora** para configurar o **AKS** com o **KubeVirt**. É necessário ter os seguintes componentes instalados:

- [Docker Engine CE v19.03.12+](https://docs.docker.com/get-docker/)
- [Kubernetes CLI (kubectl) v1.18+](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Kubernetes Krew v0.3.4+](https://krew.sigs.k8s.io/docs/user-guide/setup/install/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=dnf)

Na apresentação, foi utilizado um **Dell Inc. Latitude 7490** com **Fedora Workstation 40**, mas a demonstração funcionará com:

- **SO:** Ubuntu/Fedora/Debian/CentOS/RHEL
- **CPU:** 2GHz+ com 2 cores
- **RAM:** 8GB
- **HDD:** 20GB livres.

## Roteiro de Preparo

### 1) Autenticar no Azure CLI

Antes de criar qualquer recurso, é necessário autenticar-se no Azure CLI. Execute o seguinte comando:

```bash
az login

ou 

az login --use-device-code
```

### 2) Criar o Resource Group

Crie o Resource Group que será utilizado para o cluster AKS:

```bash
az group create --name rg-kubervirt-demo-eastus2 --location eastus2
```

### 3) Criar o cluster Kubernetes com AKS

```bash
az aks create \
  --resource-group rg-kubervirt-demo-eastus2 \
  --name kubevirt \
  --node-count 1 \
  --node-vm-size Standard_D4s_v3 \
  --kubernetes-version 1.29.7 \
  --generate-ssh-keys \
  --enable-managed-identity \
  --enable-addons monitoring \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 5 \
  --network-plugin azure \
  --vm-set-type VirtualMachineScaleSets


```

### 4) Configurar o kubectl para usar o AKS

```bash
az aks get-credentials --resource-group rg-kubervirt-demo-eastus2 --name kubevirt
ou 
az aks get-credentials --resource-group rg-kubervirt-demo-eastus2 --name kubevirt --overwrite-existing
kubectl get node
```

### 5) Instalar o operator do KubeVirt

Baixe e instale a versão 1.2.0 do KubeVirt:

```bash
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/v1.2.0/kubevirt-operator.yaml


kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/v1.2.0/kubevirt-cr.yaml

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
cd kubevirt-demo/setup/aks
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

Agora que o ambiente está configurado e os operadores do KubeVirt e CDI estão instalados, você pode começar a criar e gerenciar VMs no cluster AKS.

Para mais detalhes sobre o uso, consulte a documentação oficial do [KubeVirt](https://kubevirt.io/user-guide/).
