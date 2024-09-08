# Demonstração - Atividades

## Requisitos

Este roteiro foi testado com as versões `v1.3.1` do KubeVirt e `v1.60.2` do CDI.

## Roteiro

### 0) Verificar diretório correto

```bash
git clone https://github.com/paulnune/kubevirt-demo

cd kubevirt-demo/tasks

ou 

cd ../../tasks/aks/

```

### 1) Validar recursos do KubeVirt e CDI no ambiente

bash

```bash
kubectl api-resources | grep kubevirt.io
```

### 2) Criar uma VirtualMachine com a imagem Cirrus.

Cirros é uma distribuição Linux leve, projetada para ser utilizada em testes e demonstrações em ambientes de cloud, como OpenStack e Kubernetes. No contexto do KubeVirt, essa imagem será usada para simular o comportamento de uma máquina virtual em um cluster Kubernetes, facilitando o desenvolvimento, testes e demonstrações.

```bash
cat vm-cirrus.yml

kubectl apply -f vm-cirrus.yml
```

### 3) Verificar a criação da VirtualMachineInstance (VMI)

Depois da dua criação, vemos que a `VirtualMachine` ainda não tem uma `VirtualMachineInstance` criada. Isso se dá porque não definimos o `spec.running` como `true`.

```bash
kubectl get vm,vmi
```

### 4) Habilitar o campo spec.running e criar a VirtualMachineInstance

Podemos modificar esse campo da mesma forma que fazemos com outros recursos do Kubernetes. E vemos que o KubeVirt já começa a criar nossa instância:

```bash
kubectl patch virtualmachine cirrus-vm-1 --type merge -p '{"spec":{"running":true}}'

kubectl get vm,vmi
```

### 5) Acessar a console serial da VM com a CLI do KubeVirt

A CLI do KubeVirt nos fornece facilidades como, por exemplo, acesso a console (serial):

**User**: cirros
**Password**: gocubsgo

```bash
kubectl virt console cirrus-vm-1
```

### 6) Parar a VirtualMachine via CLI do KubeVirt

"Atalho" para manipular o campo `spec.running`:

```bash
kubectl virt stop cirrus-vm-1

kubectl get vm,vmi
```

### 7) Criar um StorageClass com Immediate BindingMode

Vamos criar um StorageClass customizado definindo o volumeBindingMode: Immediate. Isso garantirá que o volume seja provisionado imediatamente ao invés de esperar pelo primeiro consumidor.

```bash
cat storage-classe-custom.yml

kubectl apply -f storage-classe-custom.yml
```

### 8) Utilizar o Containerized Data Importer (CDI) com DataVolume

Outro componente importante é o Containerized Data Importer (CDI), que fornece o recurso de `DataVolume` e permite importar discos KVM de forma automática (qcow2, raw, etc) para serem usados com o KubeVirt. Ele fornece automação e abstração em relação aos `PersistentVolumeClaim`.

```bash
cat cdi-dv-ubuntu.yml

kubectl apply -f cdi-dv-ubuntu.yml
```

### 9) Acompanhar o processo de criação do DataVolume

Esse processo pode ser acompanhado usando via logs ou CLI:

```bash
kubectl get dv,pvc

```

### 10) Criar uma VirtualMachine com o DataVolume

Vamos criar uma outra `VirtualMachine` usando o `DataVolume`:

```bash
cat vm-ubuntu.yml

kubectl apply -f vm-ubuntu.yml
```

### 11) Acompanhar a automação do DataVolume

Esse processo vai disparar uma automação de clonagem do `DataVolume` que importamos anteriormente, antes da execução propriamente dita da `VirtualMachineInstance`:

```bash
kubectl get vm,vmi,dv,pvc
```

### 12) Acessar a console gráfica (VNC)

Além de acesso a console serial, também podemos acessar a console gráfica (VNC) via CLI do KubeVirt (virtctl):

**User**: ubuntu
**Password**: kubevirt

```bash
kubectl virt vnc ubuntu-vm-1
```

Ou via console como fizemos anteriormente:

```bash
kubectl virt console ubuntu-vm-1
```

### 13) Reiniciar a VirtualMachine (re-scheduling)

Dado que a nossa máquina é baseada em um disco persistente, podemos reinicia-la (re-scheduling) sem perda de dados:

```bash
kubectl virt restart ubuntu-vm-1
```

### 14) Expor serviços da VirtualMachineInstance 

Outra facilidade via CLI do KubeVirt (virtctl) é a exposição de serviços:

```bash
kubectl virt expose vmi fedora-vm-1 --name=fedora-vm-ssh --port=22 --type=LoadBalancer

kubectl get svc fedora-vm-ssh

kubectl get nodes -o wide

ssh fedora@<ip do node> -p <porta externa do svc>

```

### 15) Limpar recursos para novas atividades

Não esqueça de apagar os recursos para abrir espaço para novas aventuras!

```bash
kubectl delete vm cirrus-vm-1 ubuntu-vm-1

kubectl delete dv ubuntu-cloud-base

az aks delete \
  --resource-group rg-kubervirt-demo-eastus2 \
  --name kubevirt \
  --yes \
  --no-wait
  
```
