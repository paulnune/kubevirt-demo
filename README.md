# KubeVirt no AKS: Integração de VMs e Workloads Cloud-Native

[![Licença Apache License version 2.0](https://img.shields.io/github/license/kubevirt/kubevirt.svg)](https://www.apache.org/licenses/LICENSE-2.0)

## Sobre

Este repositório contém os artefatos, slides e demonstrações que usamos na apresentação **KubeVirt no AKS: Integração de VMs e Workloads Cloud-Native**. Exploramos como integrar máquinas virtuais (VMs) e workloads cloud-native em um ambiente Kubernetes gerenciado pelo AKS (Azure Kubernetes Service).

Mais informações sobre a apresentação e outros conteúdos podem ser encontrados [no meu site pessoal](https://www.paulonunes.dev/).

## Sobre o Apresentador

Eu sou **Paulo Nunes**, Cloud Solutions Architect com experiência em DevOps/SRE, com mais de 12 anos de experiência. Sou especializado em nuvens públicas como **Azure, AWS** e **GCP**, além de Kubernetes (AKS, EKS, GKE).

## Estrutura do Repositório

Neste repositório, vocês encontrarão:

- [Apresentação Teórica](slides.pdf): Uma visão geral sobre KubeVirt, AKS e a integração de VMs em ambientes Kubernetes.
- [Demonstração - Preparo do Ambiente no AKS](setup-aks/README.md): Passo a passo para configurar um ambiente AKS com KubeVirt, voltado para produção.
- [Demonstração - Preparo do Ambiente no Kind](setup-kind/README.md): Passo a passo para configurar um ambiente local com Kind e KubeVirt para testes.
- [Demonstração - Atividades](tasks/README.md): Atividades práticas para testar e validar a integração de VMs com workloads cloud-native no AKS.

## Requisitos

Para seguir as demonstrações e atividades, é necessário ter:

### AKS

#### Requisitos

- Uma conta **Azure** com permissão para criar e gerenciar recursos no AKS.
- **Azure CLI** instalado e configurado.
- **kubectl** configurado para acessar seu cluster AKS.
- KubeVirt instalado no AKS para ambientes produtivos.
- Suporte a **StorageClass** no AKS para volumes persistentes.

#### Configuração do Ambiente

No [guia de preparo do ambiente na Azure](setup-aks/README.md), detalhamos como configurar o AKS e instalar o KubeVirt. Os passos incluem:

1. Provisionar um cluster AKS.
2. Configurar redes e volumes de armazenamento para suportar VMs.
3. Instalar e configurar o KubeVirt no AKS.
4. Testar o ambiente com workloads de VMs e containers.

### Kind

#### Requisitos no Kind (para testes locais)

- **Docker** instalado e configurado.
- **Kind** (Kubernetes in Docker) instalado e configurado.
- **kubectl** configurado para acessar o cluster local.
- Um cluster Kubernetes local criado usando Kind.
- KubeVirt instalado no Kind, com suporte para armazenamento local para desenvolvimento.

#### Configuração do Ambiente

No [guia de preparo do ambiente local](setup-kind/README.md), detalhamos como configurar o Kind e instalar o KubeVirt. Os passos incluem:

1. Provisionar um cluster Kind.
2. Configurar redes e volumes de armazenamento para suportar VMs.
3. Instalar e configurar o KubeVirt no Kind.
4. Testar o ambiente com workloads de VMs e containers.

## Cluster Configurado (AKS ou Kind)

### Demonstração Prática

As [atividades práticas](tasks/README.md) incluem exemplos de:

1. Criar e gerenciar VMs no Kubernetes com KubeVirt no AKS e Kind.
2. Executar workloads containerizados ao lado de VMs.
3. Migrar workloads legados para containers.
4. Utilizar ferramentas de monitoramento e escalabilidade no AKS e no Kind.
