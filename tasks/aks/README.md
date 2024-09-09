
# 🛠️ Demonstração - Atividades no AKS

## ✅ Requisitos

Este roteiro foi testado com as versões `v1.2.0` do KubeVirt e `v1.60.2` do CDI.

## 📝 Roteiro

### 0️⃣ Verificar diretório correto

Antes de começar, certifique-se de estar no diretório correto com os artefatos necessários:

```bash
git clone https://github.com/paulnune/kubevirt-demo
cd kubevirt-demo/tasks
# ou
cd ../../tasks/aks/
```

### 1️⃣ Validar recursos do KubeVirt e CDI no ambiente

Verifique se os recursos do KubeVirt estão corretamente disponíveis:

```bash
kubectl api-resources | grep kubevirt.io
```

### 2️⃣ Criar uma VirtualMachine com a imagem Cirrus

Cirros é uma distribuição Linux leve, projetada para testes em ambientes de cloud. Neste passo, criamos uma VirtualMachine utilizando essa imagem:

```bash
cat vm-cirrus.yml
kubectl apply -f vm-cirrus.yml
```

### 3️⃣ Verificar a criação da VirtualMachineInstance (VMI)

Confirme a criação da VirtualMachineInstance:

```bash
kubectl get vm,vmi
```

A `VirtualMachine` não terá uma `VirtualMachineInstance` até que o campo `spec.running` seja definido como `true`.

### 4️⃣ Habilitar o campo spec.running e criar a VirtualMachineInstance

Modifique o campo `spec.running` para iniciar a VM:

```bash
kubectl patch virtualmachine cirrus-vm-1 --type merge -p '{"spec":{"running":true}}'
kubectl get vm,vmi
```

### 5️⃣ Acessar a console serial da VM com a CLI do KubeVirt

Use a CLI do KubeVirt para acessar a console serial da VM. As credenciais padrão são:

**Usuário**: cirros  
**Senha**: gocubsgo

```bash
kubectl virt console cirrus-vm-1
```

### 6️⃣ Parar a VirtualMachine via CLI do KubeVirt

Pare a VM diretamente com a CLI do KubeVirt:

```bash
kubectl virt stop cirrus-vm-1
kubectl get vm,vmi
```

### 7️⃣ Criar um StorageClass com Immediate BindingMode

Crie um StorageClass com `Immediate` BindingMode, que provisiona o volume imediatamente:

```bash
cat storage-classe-custom.yml
kubectl apply -f storage-classe-custom.yml
```

### 8️⃣ Utilizar o Containerized Data Importer (CDI) com DataVolume

Use o CDI para importar discos KVM de forma automática:

```bash
cat cdi-dv-ubuntu.yml
kubectl apply -f cdi-dv-ubuntu.yml
```

### 9️⃣ Acompanhar o processo de criação do DataVolume

Acompanhe o progresso da criação do DataVolume:

```bash
kubectl get dv,pvc
```

### 🔟 Criar uma VirtualMachine com o DataVolume

Crie uma VirtualMachine utilizando o DataVolume criado anteriormente:

```bash
cat vm-ubuntu.yml
kubectl apply -f vm-ubuntu.yml
```

### 1️⃣1️⃣ Acompanhar a automação do DataVolume

Verifique o progresso da clonagem e execução da VirtualMachine:

```bash
kubectl get vm,vmi,dv,pvc
```

### 1️⃣2️⃣ Acessar a console gráfica (VNC)

Acesse a console gráfica (VNC) da VM:

**Usuário**: ubuntu  
**Senha**: kubevirt

```bash
kubectl virt vnc ubuntu-vm-1
# ou via console:
kubectl virt console ubuntu-vm-1
```

### 1️⃣3️⃣ Reiniciar a VirtualMachine (re-scheduling)

Reinicie a VM sem perder dados:

```bash
kubectl virt restart ubuntu-vm-1
```

### 1️⃣4️⃣ Expor serviços da VirtualMachineInstance

Exponha serviços da VM utilizando a CLI do KubeVirt:

```bash
kubectl virt expose vmi ubuntu-vm-1 --name=ubuntu-vm-ssh --port=22 --type=LoadBalancer
kubectl get svc ubuntu-vm-ssh
kubectl get nodes -o wide
ssh ubuntu@<ip público do node> 
```

### 1️⃣5️⃣ Limpar recursos para novas atividades

Lembre-se de limpar os recursos após finalizar suas atividades:

```bash
kubectl delete vm cirrus-vm-1 ubuntu-vm-1
kubectl delete dv ubuntu-cloud-base

az aks delete \
  --resource-group rg-kubervirt-demo-eastus2 \
  --name kubevirt \
  --yes \
  --no-wait
```
