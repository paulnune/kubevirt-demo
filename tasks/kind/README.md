
# 🛠️ Demonstração - Atividades no Kind

## ✅ Requisitos

Este roteiro foi testado com as versões `v1.2.0` do KubeVirt e `v1.60.2` do CDI.

## 📝 Roteiro

### 1️⃣ Verificar diretório correto

Certifique-se de estar no diretório correto:

```bash
git clone https://github.com/paulnune/kubevirt-demo
cd kubevirt-demo/tasks/kind
# ou
cd ../../tasks/kind/
```

### 2️⃣ Validar recursos do KubeVirt e CDI no ambiente

Verifique se os recursos do KubeVirt estão corretamente disponíveis:

```bash
kubectl api-resources | grep kubevirt.io
```

### 3️⃣ Criar uma VirtualMachine com a imagem Cirrus

Cirros é uma distribuição Linux leve, projetada para testes em ambientes de cloud. Neste passo, criamos uma VirtualMachine utilizando essa imagem:

```bash
cat vm-cirrus.yml
kubectl apply -f vm-cirrus.yml
```

### 4️⃣ Verificar a criação da VirtualMachineInstance (VMI)

Confirme a criação da VirtualMachineInstance:

```bash
kubectl get vm,vmi
```

A `VirtualMachine` não terá uma `VirtualMachineInstance` até que o campo `spec.running` seja definido como `true`.

### 5️⃣ Habilitar o campo spec.running e criar a VirtualMachineInstance

Modifique o campo `spec.running` para iniciar a VM:

```bash
kubectl patch virtualmachine cirrus-vm-1 --type merge -p '{"spec":{"running":true}}'
kubectl get vm,vmi
```

### 6️⃣ Acessar a console serial da VM com a CLI do KubeVirt

Use a CLI do KubeVirt para acessar a console serial da VM. As credenciais padrão são:

**Usuário**: cirros  
**Senha**: gocubsgo

```bash
kubectl virt console cirrus-vm-1
```

### 7️⃣ Parar a VirtualMachine via CLI do KubeVirt

Pare a VM diretamente com a CLI do KubeVirt:

```bash
kubectl virt stop cirrus-vm-1
kubectl get vm,vmi
```

### 8️⃣ Instalar o HostPath Provisioner Operator

Para provisionar volumes locais no ambiente Kind, o **HostPath Provisioner Operator** precisa ser instalado:

#### [Link](https://github.com/kubevirt/hostpath-provisioner-operator) do KubeVirt hostpath provisioner

A partir da versão 0.11, o operador hostpath provisioner agora requer que o cert manager seja instalado antes de implantar o operador. Isso ocorre porque o operador agora tem um webhook de validação que verifica se o conteúdo do CR é válido. Antes de implantar o operador, você precisa instalar o cert manager:

```bash
kubectl create -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
kubectl wait --for=condition=Available -n cert-manager --timeout=120s --all deployments
```

Em seguida, você precisa criar o namespace do provisionador hostpath:

```bash
kubectl create -f https://raw.githubusercontent.com/kubevirt/hostpath-provisioner-operator/main/deploy/namespace.yaml
```

Seguido pelo webhook:

```bash
kubectl create -f https://raw.githubusercontent.com/kubevirt/hostpath-provisioner-operator/main/deploy/webhook.yaml -n hostpath-provisioner
```

E então você pode criar o operador:

```bash
kubectl create -f https://raw.githubusercontent.com/kubevirt/hostpath-provisioner-operator/main/deploy/operator.yaml -n hostpath-provisioner
```

Após a instalação, crie o Custom Resource para definir como o provisionamento será realizado:

```bash
kubectl apply -f hostpathprovisioner.yml
```

### 9️⃣ Criar um StorageClass com Immediate BindingMode

Crie o StorageClass necessário para suportar volumes persistentes com binding imediato:

```bash
cat storage-classe-custom.yml
kubectl apply -f storage-classe-custom.yml
```

### 🔟 Utilizar o Containerized Data Importer (CDI) com DataVolume

Agora, utilize o CDI para importar discos de forma automática:

```bash
cat cdi-dv-ubuntu.yml
kubectl apply -f cdi-dv-ubuntu.yml
```

### 1️⃣1️⃣ Acompanhar o processo de criação do DataVolume

Acompanhe o progresso da criação do DataVolume:

```bash
kubectl get dv,pvc
```

### 1️⃣2️⃣ Criar uma VirtualMachine com o DataVolume

Crie uma VirtualMachine utilizando o DataVolume criado anteriormente:

```bash
cat vm-ubuntu.yml
kubectl apply -f vm-ubuntu.yml
```

### 1️⃣3️⃣ Acompanhar a automação do DataVolume

Verifique o progresso da clonagem e execução da VirtualMachine:

```bash
kubectl get vm,vmi,dv,pvc
```

### 1️⃣4️⃣ Acessar a console gráfica (VNC)

Acesse a console gráfica (VNC) da VM:

```bash
kubectl virt vnc ubuntu-vm-1
# ou via console:
kubectl virt console ubuntu-vm-1
```

### 1️⃣5️⃣ Reiniciar a VirtualMachine (re-scheduling)

Reinicie a VM sem perder dados:

```bash
kubectl virt restart ubuntu-vm-1
```

### 1️⃣6️⃣ Expor serviços da VirtualMachineInstance via NodePort

Exponha serviços da VM utilizando a CLI do KubeVirt:

```bash
kubectl virt expose vmi ubuntu-vm-1 --name=ubuntu-vm-ssh --port=22 --type=NodePort
kubectl get svc ubuntu-vm-ssh -o wide
kubectl get nodes -o wide
ssh -p <porta externa do svc> ubuntu@<ip do node> 
```

### 1️⃣7️⃣ Limpar recursos para novas atividades

Lembre-se de limpar os recursos após finalizar suas atividades:

```bash
kubectl delete vm cirrus-vm-1 ubuntu-vm-1
kubectl delete dv ubuntu-cloud-base
kind delete cluster
```
