# 🚀 BlicioLab - Home Lab DevOps & GitOps

Bem-vindo ao repositório oficial da infraestrutura e dos manifestos do **BlicioLab**. Este projeto tem como objetivo central a criação, orquestração e automação de uma arquitetura de nuvem híbrida e moderna em um ambiente físico (*Home Lab*), aplicando na prática os principais conceitos de Engenharia DevOps, Containers e Entrega Contínua (CI/CD).

---

## 🛠️ Tecnologias e Linguagens Utilizadas

O ecossistema do laboratório foi construído utilizando ferramentas de padrão corporativo:

* **Orquestração de Containers:** Kubernetes (K3s distribuído em Control Plane e Worker Node)
* **Servidor de Virtualização:** Proxmox VE 9.1.1
* **Automação e CI/CD:** GitHub Actions (com Self-Hosted Runner local)
* **Servidor Web / Proxy:** Nginx (Alpine) com gerenciamento via ConfigMaps e Services (NodePort)
* **Redes e Roteamento:** Roteador TP-Link ER605 com regras de NAT e Port Forwarding
* **Gerenciamento de Borda / DNS:** Cloudflare (Gerenciamento de DNS e Proxy Reverso)
* **Linguagens e Formatos:** * `YAML` (Manifestos declarativos do Kubernetes e workflows da esteira)
  * `HTML5 / CSS3` (Página web customizada da BlicioLab)
  * `Bash / Shell Script` (Automação de comandos e testes internos)
  * `Git & GitHub` (Controle de versão e versionamento de infraestrutura)

---

## 🏗️ Arquitetura do Laboratório (Proxmox VE)

A infraestrutura está dividida em máquinas virtuais dedicadas dentro do Proxmox, simulando um ambiente de cluster real de alta disponibilidade:

```text
[ Internet / Clientes ]
         │
         ▼
[ Cloudflare (DNS / Proxy) ]
         │
         ▼
[ Roteador TP-Link ER605 ] (NAT / Port Forwarding na porta 80/30080)
         │
         ▼
┌────────────────────────────────────────────────────────┐
│               Proxmox VE (Home Lab)                    │
│                                                        │
│  ┌────────────────────────┐  ┌───────────────────────┐ │
│  │   k3s-node01           │  │   k3s-worker01        │ │
│  │   (Control-Plane)      │  │   (Worker Node)       │ │
│  │   IP: 192.168.0.10     │  │   IP: 192.168.0.11    │ │
│  │   - 2 Réplicas Nginx   │  │   - 2 Réplicas Nginx  │ │
│  └────────────────────────┘  └───────────────────────┘ │
└────────────────────────────────────────────────────────┘

Balanceamento Nativo (K3s CNI Flannel + Kube-Proxy): O tráfego que chega na porta do nó é distribuído de forma inteligente entre as réplicas dos pods espalhadas no Control-Plane e no Worker.

Pipeline GitOps: Qualquer alteração efetuada nos arquivos de manifesto via git push aciona o GitHub Actions, que se comunica com o Runner local e aplica as mudanças de forma declarativa direto no cluster.

🧗 Desafios e Dificuldades Superados até o Momento
Durante a montagem e a evolução deste laboratório de engenharia, enfrentamos e solucionamos diversos cenários complexos do mundo real:

Configuração de Port Forwarding e Borda de Rede:

Desafio: Garantir que as requisições vindas da internet cruzassem o roteador ER605 e chegassem corretamente nas portas expostas do cluster Kubernetes.

Solução: Alinhamento das regras de NAT (Virtual Server) mapeando a porta de entrada com o IP estático correto do nó do cluster.

Terminação SSL e Conflitos de Protocolo (HTTP vs HTTPS):

Desafio: O acesso via HTTPS (443) gerava erros de protocolo (ERR_SSL_PROTOCOL_ERROR / Erro 521) porque a aplicação respondia inicialmente apenas em HTTP puro (80).

Solução: Estudo aprofundado do fluxo de proxy reverso da Cloudflare e alinhamento dos certificados de borda com a infraestrutura interna.

Sincronização de Arquivos Estáticos via GitOps (ConfigMaps):

Desafio: Substituir a página padrão de boas-vindas do Nginx e injetar a identidade visual e o logotipo oficial da BlicioLab sem corromper as permissões do container ou gerar cache estático obsoleto.

Solução: Implementação de volumes baseados em ConfigMaps associados a comandos de rollout restart na esteira de CI/CD para forçar o recarregamento limpo dos pods.

Tratamento de Dados Binários no Kubernetes:

Desafio: Tentativa inicial de armazenar imagens diretamente em ConfigMaps via codificação binária (binaryData), o que gerou erros de validação de codificação de bytes (illegal base64 data).

Solução: Migração para uma abordagem mais limpa e performática, referenciando os ativos visuais diretamente através de URLs diretas (raw) versionadas no próprio repositório Git.

Pagina de Teste: http://app.bliciolab.com.br:30080/