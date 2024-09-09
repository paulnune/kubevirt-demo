
# 🌐 KubeVirt no AKS: Integração de VMs e Workloads Cloud-Native

[![Licença Apache License version 2.0](https://img.shields.io/github/license/kubevirt/kubevirt.svg)](https://www.apache.org/licenses/LICENSE-2.0)

## 📖 Sobre

Este repositório contém os artefatos, slides e demonstrações usados na apresentação **KubeVirt no AKS: Integração de VMs e Workloads Cloud-Native**. Exploramos a integração de máquinas virtuais (VMs) e workloads cloud-native em ambientes Kubernetes gerenciados pelo AKS e também localmente com o **Kind**.

🔗 Mais informações sobre a apresentação e outros conteúdos podem ser encontrados [no meu site pessoal](https://www.paulonunes.dev/).

## 👨‍🏫 Sobre o Apresentador

Eu sou **Paulo Nunes**, Cloud Solutions Architect com experiência em DevOps/SRE, com mais de 12 anos de experiência. Sou especializado em nuvens públicas como **Azure, AWS** e **GCP**, além de Kubernetes (AKS, EKS, GKE).

## 🗂️ Estrutura do Repositório

Neste repositório, você encontrará:

- 📊 [Apresentação Teórica](/slides/aulaunica.pdf): Uma visão geral sobre KubeVirt, AKS e a integração de VMs em ambientes Kubernetes.

## ☁️ Ambiente no AKS

- 🛠️ [Demonstração - Preparo do Ambiente](setup/aks/README.md): Passo a passo para configurar um ambiente AKS com KubeVirt.
- 🚀 [Demonstração - Atividades](tasks/aks/README.md): Atividades práticas para testar e validar a integração de VMs com workloads cloud-native no AKS.

## 🖥️ Ambiente Local (Kind)

Além do AKS, também incluímos demonstrações locais usando **Kind**:

- 🛠️ [Demonstração - Preparo do Ambiente](setup/kind/README.md): Passo a passo para configurar um ambiente local com Kind e KubeVirt para testes.
- 🚀 [Demonstração - Atividades](tasks/kind/README.md): Atividades práticas para testar e validar a integração de VMs com workloads cloud-native localmente no Kind.

## ✅ Requisitos Gerais

Para seguir as demonstrações e atividades, é necessário:

### Para o AKS:

#### Requisitos:

- Uma conta **Azure** com permissões para criar e gerenciar recursos no AKS.
- **Azure CLI** instalado e configurado.
- **kubectl** configurado para acessar seu cluster AKS.
- KubeVirt instalado no AKS para ambientes produtivos.
- Suporte a **StorageClass** no AKS para volumes persistentes.

#### Configuração do Ambiente

No [guia de preparo do ambiente no AKS](setup/aks/README.md), detalhamos como configurar e instalar o KubeVirt. Os passos incluem:

1. 🚧 Provisionar um cluster AKS.
2. 🛠️ Instalar e configurar o KubeVirt no AKS.

#### Demonstração Prática no AKS

As [atividades práticas no AKS](tasks/aks/README.md) incluem:

1. 🖥️ Criação e gerenciamento de VMs no AKS usando KubeVirt.
2. Utilização de StorageClass e Containerized Data Importer (CDI).

### Para o Kind (Ambiente Local):

#### Requisitos:

- **Docker** instalado e configurado.
- **Kind** instalado.
- **kubectl** e **KubeVirt CLI** configurados para acessar seu cluster Kind.

#### Configuração do Ambiente

No [guia de preparo do ambiente local com Kind](setup/kind/README.md), detalhamos como configurar o Kind e instalar o KubeVirt para testes locais.

#### Demonstração Prática no Kind

As [atividades práticas no Kind](tasks/kind/README.md) incluem:

1. 🖥️ Criação e gerenciamento de VMs no Kind usando KubeVirt.
2. Utilização do **HostPath Provisioner** para armazenamento persistente e volumes locais.