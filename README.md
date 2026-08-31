# fiap-14soat-tc-fase5-observability

![Prometheus](https://img.shields.io/badge/Prometheus-v2.51-%23E6522C.svg?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-10.4-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)
![New Relic](https://img.shields.io/badge/New_Relic-%231CE783.svg?style=for-the-badge&logo=newrelic&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2.x-%232496ED.svg?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-%23326CE5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-%230F1689.svg?style=for-the-badge&logo=helm&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Hexagonal Architecture](https://img.shields.io/badge/Hexagonal-Architecture-7B2D8B?style=for-the-badge)
![Event-Driven](https://img.shields.io/badge/Event--Driven-FF6D00?style=for-the-badge)

---

## 📑 Sumário

- [👤 Autor](#-autor)
- [📋 Descrição](#-descrição)
- [🔭 O que é Observabilidade](#-o-que-é-observabilidade)
- [🏗️ Arquitetura de Observabilidade](#️-arquitetura-de-observabilidade)
- [🛠️ Tecnologias Utilizadas](#️-tecnologias-utilizadas)
- [🔍 New Relic — Observabilidade Complementar (Opcional)](#-new-relic--observabilidade-complementar-opcional)
- [📊 Prometheus + Grafana — Observabilidade Local](#-prometheus--grafana--observabilidade-local)
- [📈 Dashboards Grafana](#-dashboards-grafana)
- [🚨 Alertas Configurados](#-alertas-configurados)
- [🔒 Proteção da Branch main](#-proteção-da-branch-main)
- [🚀 Execução](#-execução)
- [🔗 Repositórios Relacionados](#-repositórios-relacionados)

---

## 👤 Autor

| Nome | E-mail | RM | Discord | WhatsApp |
|------|--------|-----|---------|---------|
| Jonas Fernando Schuh | jonasschuh@hotmail.com | rm369458 | jonasf.schuh | 47 9 9960-1396 |

**Grupo:** 2 · FIAP 14SOAT Fase 5 — Hackathon

---

## 📋 Descrição

Este repositório centraliza toda a configuração de **observabilidade** da plataforma **FIAP X**. Não contém código Java — é composto por arquivos de configuração YAML/JSON e Docker Compose.

> ⚠️ **Este repositório não tem código Java.** Ele contém apenas configurações de monitoramento que os demais microserviços consomem. A stack de observabilidade pode ser executada de duas formas: via **Docker Compose** (desenvolvimento local sem cluster) ou via **cluster Kubernetes local** (Docker Desktop), onde é provisionada automaticamente pelo repositório [fiap-14soat-tc-fase5-iac-terraform](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-iac-terraform).

### Responsabilidades deste repositório

| Ferramenta | Ambiente | Função |
|---|---|---|
| **New Relic APM** | Opcional | APM, distributed tracing, logs, alertas (agente já instalado em todos os serviços) |
| **Prometheus** | Local (Docker Compose) + K8s cluster local | Coleta de métricas via `/actuator/prometheus` dos 5 serviços |
| **Grafana** | Local (Docker Compose) + K8s cluster local | Dashboards visuais, 6 dashboards pré-configurados e auto-provisionados |
| **Spring Boot Actuator** | Todos os serviços | Expõe `/actuator/health`, `/actuator/metrics`, `/actuator/prometheus` |

### Escopo funcional

Este projeto entrega:

- `docker-compose.yml` para subir **Prometheus + Grafana** (modo Docker Compose)
- configuração Helm para subir **Prometheus + Grafana** no K8s local (via repositório IAC Terraform)
- regras Prometheus versionadas em Git
- dashboards Grafana como código
- documentação de uso do **New Relic** (opcional)
- scripts `.bat` para subir e parar o stack local via Docker Compose
- workflow GitHub Actions para validar YAMLs, JSONs e regras de alerta

### Microserviços monitorados

| Serviço | Porta | Container name | Endpoint de métricas |
|---|---|---|---|
| `video-upload-service` | `8083` | `video-upload-api` | `/actuator/prometheus` |
| `video-processing-service` | `8084` | `video-processing-api` | `/actuator/prometheus` |
| `video-status-service` | `8085` | `video-status-api` | `/actuator/prometheus` |
| `video-download-service` | `8086` | `video-download-api` | `/actuator/prometheus` |
| `notification-service` | `8087` | `notification-api` | `/actuator/prometheus` |

Todos os serviços:

- expõem `/actuator/health`
- expõem `/actuator/prometheus`
- já possuem `newrelic.yml`
- já recebem `NEW_RELIC_LICENSE_KEY` via `.env`
- conectam-se à rede Docker externa `fiap-network`

---

## 🔭 O que é Observabilidade

Observabilidade é a capacidade de entender o estado interno de um sistema a partir de suas **saídas externas** (métricas, logs e traces). Para este projeto, o repositório `observability` centraliza toda a configuração necessária para **monitorar, visualizar e alertar** sobre o comportamento dos microserviços em tempo real.

> Sem observabilidade, você só descobre que algo está errado quando o usuário reclama. Com ela, você descobre antes.

### O que o repositório `observability` contém

```text
fiap-14soat-tc-fase5-observability/
├── docker-compose.yml              ← Prometheus + Grafana (ambiente local)
├── prometheus/
│   ├── prometheus.yml              ← Configuração de scrape de todos os serviços
│   └── rules/
│       ├── service_alerts.yml      ← Alertas de disponibilidade (health check)
│       ├── http_alerts.yml         ← Alertas de HTTP/JVM
│       └── processing_alerts.yml   ← Alertas de processamento
├── grafana/
│   ├── provisioning/
│   │   ├── datasources/
│   │   │   └── prometheus.yml      ← Configura Prometheus como datasource automático
│   │   └── dashboards/
│   │       └── dashboards.yml      ← Carrega os dashboards automaticamente
│   └── dashboards/
│       ├── 01-overview.json        ← Visão geral de todos os serviços
│       ├── 02-video-upload.json    ← Dashboard do upload-service
│       ├── 03-video-processing.json← Dashboard do processing-service
│       ├── 04-video-status.json    ← Dashboard do status-service
│       ├── 05-video-download.json  ← Dashboard do download-service
│       └── 06-notification.json    ← Dashboard do notification-service
├── newrelic/
│   └── README-newrelic.md          ← Guia do New Relic
└── .github/workflows/
    └── validate.yml                ← Validação CI
```

### Como funciona no modo Docker Compose

```text
┌───────────────────────────────────────────────────────────────┐
│  fiap-network                                                  │
│                                                                │
│  ┌──────────────┐   scrape /actuator/prometheus               │
│  │  Prometheus  │ ◄──────────────────────────────────────┐   │
│  │  :9090       │                                         │   │
│  └──────┬───────┘         ┌──────────────────┐           │   │
│         │                 │ video-upload:8083 │───────────┘   │
│         │ datasource      │ video-process:8084│───────────┐   │
│  ┌──────▼───────┐         │ video-status:8085 │           │   │
│  │   Grafana    │         │ video-download:8086│──────────┘   │
│  │  :3000       │         │ notification:8087 │───────────┐   │
│  └──────────────┘         └──────────────────┘           │   │
│                                                           │   │
└───────────────────────────────────────────────────────────┘
```

**Pré-requisito:** cada microserviço já expõe `/actuator/prometheus` via Spring Boot Actuator + Micrometer (configurado em todos os serviços com `management.endpoints.web.exposure.include: health,info,metrics,prometheus`).

### Como funciona no modo Kubernetes (cluster local Docker Desktop)

```text
┌─────────────────────────────────────────────────────────────────────┐
│  namespace: fiapx  (Kubernetes — Docker Desktop)                     │
│                                                                      │
│  ┌──────────────┐   scrape /actuator/prometheus                     │
│  │  Prometheus  │ ◄────────────────────────────────────────────┐   │
│  │  (Helm)      │                                               │   │
│  │  :9090       │         ┌──────────────────────────┐         │   │
│  └──────┬───────┘         │ video-upload-service:8083│─────────┘   │
│         │                 │ video-processing-service  │─────────┐   │
│         │ datasource      │ video-status-service:8085 │         │   │
│  ┌──────▼───────┐         │ video-download-service    │─────────┘   │
│  │   Grafana    │         │ notification-service:8087 │─────────┐   │
│  │  (Helm)      │         └──────────────────────────┘         │   │
│  │  :3000       │                                               │   │
│  └──────────────┘                                               │   │
│                                                                 │   │
└─────────────────────────────────────────────────────────────────┘
```

O provisionamento no K8s é feito automaticamente pelo script `setup-cluster.sh` do repositório [fiap-14soat-tc-fase5-iac-terraform](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-iac-terraform), que instala Prometheus e Grafana via Helm com os scrape configs e alertas pré-configurados.

**Portas locais:**

| Serviço | URL |
|---------|-----|
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3000 (admin/admin) |

### Métricas coletadas automaticamente

Cada microserviço Spring Boot expõe automaticamente (via Micrometer + Actuator) as seguintes métricas:

#### 📊 Métricas de JVM e sistema

| Métrica | Descrição |
|---------|-----------|
| `jvm_memory_used_bytes` | Uso de memória heap e non-heap |
| `jvm_gc_pause_seconds` | Pausas do Garbage Collector |
| `jvm_threads_live_threads` | Número de threads ativas |
| `process_cpu_usage` | % CPU consumida pelo processo |

#### 🌐 Métricas de HTTP (REST API)

| Métrica | Descrição |
|---------|-----------|
| `http_server_requests_seconds_count` | Total de requisições por endpoint e status |
| `http_server_requests_seconds_sum` | Soma do tempo de resposta |
| `http_server_requests_seconds_max` | Pior tempo de resposta |

Permitem calcular: **taxa de requisições**, **latência média**, **taxa de erros (5xx/4xx)**.

#### 📦 Métricas customizadas (por serviço)

| Serviço | Exemplos de métricas adicionais |
|---------|-------------------------------|
| `video-upload` | uploads por segundo, tamanho médio de arquivo, taxa de erros de validação |
| `video-processing` | vídeos processados/hora, duração média do ffmpeg, taxa de falhas |
| `video-status` | status PENDING/PROCESSING/DONE/FAILED em tempo real |
| `notification` | e-mails enviados por hora, falhas de envio |

### Por que observabilidade importa nesta arquitetura

A FIAP X é uma plataforma **event-driven** com múltiplos saltos assíncronos:

1. upload HTTP
2. gravação em storage
3. publicação em SQS
4. processamento com `ffmpeg`
5. atualização de status
6. notificação por e-mail

Sem métricas, traces e logs correlacionados, fica difícil responder perguntas como:

- onde o vídeo travou?
- o problema está no upload, no processamento ou na notificação?
- a fila está acumulando?
- a latência aumentou após uma mudança?
- houve restart em loop de um container?

---

## 🏗️ Arquitetura de Observabilidade

### Arquitetura local — Prometheus + Grafana (Docker Compose)

```text
┌───────────────────────────────────────────────────────────────┐
│  fiap-network                                                  │
│                                                                │
│  ┌──────────────┐   scrape /actuator/prometheus               │
│  │  Prometheus  │ ◄──────────────────────────────────────┐   │
│  │  :9090       │                                         │   │
│  └──────┬───────┘         ┌──────────────────┐           │   │
│         │                 │ video-upload:8083 │───────────┘   │
│         │ datasource      │ video-process:8084│───────────┐   │
│  ┌──────▼───────┐         │ video-status:8085 │           │   │
│  │   Grafana    │         │ video-download:8086│──────────┘   │
│  │  :3000       │         │ notification:8087 │───────────┐   │
│  └──────────────┘         └──────────────────┘           │   │
│                                                           │   │
└───────────────────────────────────────────────────────────┘
```

### Arquitetura K8s — Prometheus + Grafana (cluster local Docker Desktop)

```text
┌─────────────────────────────────────────────────────────────────────┐
│  namespace: fiapx  (Kubernetes — Docker Desktop)                     │
│                                                                      │
│  ┌──────────────┐   scrape /actuator/prometheus                     │
│  │  Prometheus  │ ◄────────────────────────────────────────────┐   │
│  │  Helm chart  │                                               │   │
│  │  :9090       │         ┌──────────────────────────┐         │   │
│  └──────┬───────┘         │ video-upload-service:8083│─────────┘   │
│         │                 │ video-processing-service  │─────────┐   │
│         │ datasource      │ video-status-service:8085 │         │   │
│  ┌──────▼───────┐         │ video-download-service    │─────────┘   │
│  │   Grafana    │         │ notification-service:8087 │─────────┐   │
│  │  Helm chart  │         └──────────────────────────┘         │   │
│  │  :3000       │                                               │   │
│  └──────────────┘                                               │   │
│  Provisionado via: fiap-14soat-tc-fase5-iac-terraform           │   │
└─────────────────────────────────────────────────────────────────┘
```

### New Relic — Observabilidade complementar (opcional)

```text
[Cada Serviço no cluster K8s ou Docker]
    │  New Relic Java Agent (javaagent:/app/newrelic/newrelic.jar)
    │  - Instrumenta Spring Boot automaticamente
    │  - Captura: HTTP transactions, JVM, RabbitMQ calls, DB queries
    ▼
[New Relic APM Platform]
    ├── APM Dashboard (throughput, error rate, response time, Apdex)
    ├── Distributed Tracing (rastreamento end-to-end)
    ├── Logs in Context (logs correlacionados com transações)
    ├── JVM Metrics (heap, GC, threads)
    └── Alerts & Notifications (e-mail, Slack, PagerDuty)
```

### Fluxo resumido de telemetria

| Origem | Ferramenta | Destino | Resultado |
|---|---|---|---|
| `/actuator/prometheus` dos serviços | Prometheus (Docker Compose ou K8s Helm) | TSDB local | métricas para consultas PromQL |
| Prometheus | Grafana | Dashboards provisionados | visualização em tempo real |
| JVM + Spring Boot + integrações | New Relic Java Agent (opcional) | New Relic SaaS | APM, tracing, logs e alertas |

### Estrutura do repositório

```text
fiap-14soat-tc-fase5-observability/
├── docker-compose.yml
├── prometheus/
│   ├── prometheus.yml
│   └── rules/
│       ├── service_alerts.yml
│       ├── http_alerts.yml
│       └── processing_alerts.yml
├── grafana/
│   ├── provisioning/
│   │   ├── datasources/prometheus.yml  ← Datasource com uid fixo (Docker Compose)
│   │   └── dashboards/dashboards.yml  ← Provider de dashboards (Docker Compose)
│   ├── dashboards/
│   │   ├── 01-overview.json
│   │   ├── 02-video-upload.json
│   │   ├── 03-video-processing.json
│   │   ├── 04-video-status.json
│   │   ├── 05-video-download.json
│   │   └── 06-notification.json
│   └── helm-values.yaml               ← Valores Helm para deploy K8s (namespace fiapx)
├── newrelic/
│   └── README-newrelic.md
└── .github/workflows/validate.yml
```

### Como o Docker Compose está organizado

- **Prometheus** fica ligado em `app-network` e `fiap-network`
- **Grafana** consome o Prometheus em `app-network`
- `fiap-network` é externa, pois já existe no ecossistema criado a partir do upload-service
- volumes persistem histórico de métricas e dashboards

> **No modo K8s**, o Docker Compose não é utilizado. O Prometheus e Grafana são instalados como Helm releases no namespace `fiapx` pelo repositório IAC Terraform.

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão | Uso |
|---|---|---|
| Prometheus | 2.51.0 | Coleta e armazenamento de métricas |
| Grafana | 10.4.0 | Visualização e dashboards |
| New Relic APM | 8.18.0 (Java Agent) | APM, tracing, logs, alertas (opcional) |
| Spring Boot Actuator | 3.4.5 | Expõe /actuator/prometheus em cada serviço |
| Docker | 24.x | Containerização de Prometheus e Grafana (modo Docker Compose) |
| Docker Compose | 2.x | Orquestração local sem cluster |
| Kubernetes | 1.29+ (Docker Desktop) | Cluster local onde a stack é provisionada via Helm |
| Terraform | 1.x | Provisionamento da infraestrutura no cluster K8s local |
| Helm | 3.x | Instalação de Prometheus e Grafana no K8s |
| promtool | 2.51.0 | Validação de regras Prometheus no CI |
| yamllint | Latest | Validação de YAMLs no CI |
| GitHub Actions | Latest | CI/CD |

### Complementos importantes

- **Micrometer** já está presente nos microserviços para exportar métricas Prometheus
- **Kubernetes (Docker Desktop)** é o ambiente principal de execução do cluster local
- **New Relic** é opcional e pode ser ativado fornecendo a license key via `.env`

---

## 🔍 New Relic — Observabilidade Complementar (Opcional)

Esta seção replica o guia operacional presente em [`newrelic/README-newrelic.md`](newrelic/README-newrelic.md).

O New Relic é uma ferramenta **opcional** de APM complementar. Todos os cinco microserviços Java Spring Boot da plataforma FIAP X já possuem o **New Relic Java Agent** instalado e configurado com `newrelic.yml`. Assim que a variável `NEW_RELIC_LICENSE_KEY` apontar para uma conta válida, o agente passa a enviar telemetria automaticamente para a plataforma — seja em ambiente local ou em qualquer outro ambiente.

### 1. O que o New Relic já monitora

| Recurso | O que o New Relic coleta |
|---|---|
| **APM** | throughput, tempo de resposta, Apdex, taxa de erro, transações mais lentas |
| **Distributed Tracing** | rastreamento ponta a ponta entre chamadas HTTP, filas, integrações e processamento assíncrono |
| **Logs in Context** | correlação de logs com traces e transações do APM |
| **JVM** | heap, non-heap, garbage collection, threads, classes carregadas |
| **HTTP / Spring Boot** | endpoints, método HTTP, status code, duração, erros 4xx/5xx |
| **RabbitMQ / Mensageria** | publicação e consumo de mensagens, tempo gasto nas integrações instrumentadas |

#### Cobertura por serviço

| Serviço | App name no New Relic | Cobertura principal                                                               |
|---|---|-----------------------------------------------------------------------------------|
| `video-upload-service` | `video-upload-ms` | upload HTTP, persistência, envio para RabbitMQ `video-uploaded`                   |
| `video-processing-service` | `video-processing-ms` | consumo da fila, execução do ffmpeg, geração de ZIP, integrações storage/RabbitMQ |
| `video-status-service` | `video-status-ms` | consultas e atualização de status por vídeo/usuário                               |
| `video-download-service` | `video-download-ms` | geração de presigned URL, validações e respostas HTTP                             |
| `notification-service` | `notification-ms` | consumo de eventos, processamento e envio de e-mails                              |

### 2. Como criar conta gratuita

1. Acesse [https://newrelic.com/signup](https://newrelic.com/signup)
2. Crie a conta com e-mail e senha
3. Confirme o cadastro
4. Faça login no painel

**Free tier:** 100 GB/mês de ingestão gratuita, com acesso a APM, traces, dashboards e alertas.

### 3. Como obter a License Key

1. Entre no New Relic
2. Abra **Settings**
3. Vá em **API Keys**
4. Localize a chave **Ingest - License**
5. Copie o valor

### 4. Como configurar

O `NEW_RELIC_LICENSE_KEY` já está no `.env` de cada repositório. Basta substituir o valor pelo da sua conta e reiniciar os serviços.

```env
NEW_RELIC_LICENSE_KEY=b825897cd9ec303bb173805339b7d7839d09NRAL
```

Depois da troca:

- não é necessário alterar código Java
- não é necessário reinstalar o agente
- o `newrelic.yml` já existe nos serviços

### 5. Estrutura do `newrelic.yml` explicada

| Campo | Função |
|---|---|
| `license_key` | autentica o envio da telemetria |
| `app_name` | nome da aplicação exibido no APM |
| `distributed_tracing.enabled` | habilita rastreamento ponta a ponta |
| `application_logging.enabled` | habilita captura/correlação de logs |
| `application_logging.forwarding.enabled` | envia logs automaticamente |
| `application_logging.metrics.enabled` | gera métricas derivadas de logs |
| `transaction_tracer.enabled` | captura traces de transações lentas |
| `error_collector.enabled` | registra exceções e erros |
| `jvm_metrics.enabled` | coleta heap, GC, threads e métricas da JVM |

```yaml
common: &default_settings
  license_key: ${NEW_RELIC_LICENSE_KEY}
  app_name: video-upload-ms
  distributed_tracing:
    enabled: true
  application_logging:
    enabled: true
    forwarding:
      enabled: true
    metrics:
      enabled: true
  transaction_tracer:
    enabled: true
  error_collector:
    enabled: true
  jvm_metrics:
    enabled: true
```

### 6. App names configurados por serviço

| Serviço | App name |
|---|---|
| Video Upload | `video-upload-ms` |
| Video Processing | `video-processing-ms` |
| Video Status | `video-status-ms` |
| Video Download | `video-download-ms` |
| Notification | `notification-ms` |

### 7. Distributed Tracing

Fluxo completo rastreável:

```text
POST /api/videos → RabbitMQ:video-uploaded → ffmpeg → storage → RabbitMQ:video-events → status update → email
```

Leitura recomendada do trace:

| Etapa | Evidência esperada |
|---|---|
| `POST /api/videos` | transação web no `video-upload-ms` |
| `RabbitMQ:video-uploaded` | salto assíncrono entre upload e processamento |
| `ffmpeg` | aumento de tempo e uso de recursos no `video-processing-ms` |
| `storage` | acesso ao volume compartilhado de vídeos |
| `RabbitMQ:video-events` | publicação/consumo para status e notificações |
| `status update` | transação do `video-status-ms` |
| `email` | operação final do `notification-ms` |

### 8. Como criar alertas no New Relic

| Alerta | Regra sugerida | Severidade |
|---|---|---|
| **Apdex baixo** | `Apdex < 0.8` | warning |
| **Taxa de erro alta** | `Error rate > 5%` | critical |
| **Heap JVM alta** | `JVM heap > 85%` | warning |
| **Tempo de resposta alto** | `Response time > 2s` | warning |

Passos:

1. Abrir **Alerts & AI**
2. Criar uma **Policy**
3. Adicionar condição **APM** ou **NRQL**
4. Selecionar app
5. Definir limiar, janela e canal de notificação

### 9. Diferença entre New Relic e Prometheus + Grafana

| Plataforma | Ambiente principal | Objetivo |
|---|---|---|
| **New Relic** | Uso complementar (opcional) | APM completo, distributed tracing, logs, visão gerenciada e alertas |
| **Prometheus + Grafana** | Local (Docker Compose) + K8s cluster local | coleta local de métricas técnicas, dashboards versionados e troubleshooting rápido |

#### Quando usar cada um

- **Cluster K8s local (Docker Desktop):** priorize **Prometheus + Grafana** — já provisionado automaticamente pelo IAC Terraform
- **Docker Compose (sem cluster):** use **Prometheus + Grafana** via `docker-start-local-dev.bat`
- **New Relic:** opcional para APM avançado, distributed tracing e correlação de logs

---

## 📊 Prometheus + Grafana — Observabilidade Local

### Como funciona

O Prometheus realiza **scrape** periódico no endpoint `/actuator/prometheus` de cada microserviço. As métricas são armazenadas em sua base local e ficam disponíveis para consultas PromQL. O Grafana usa o Prometheus como datasource padrão e carrega todos os dashboards automaticamente via provisioning.

### Targets configurados

| Job Prometheus | Target |
|---|---|
| `prometheus` | `localhost:9090` |
| `video-upload-service` | `video-upload-api:8083` |
| `video-processing-service` | `video-processing-api:8084` |
| `video-status-service` | `video-status-api:8085` |
| `video-download-service` | `video-download-api:8086` |
| `notification-service` | `notification-api:8087` |

### Métricas coletadas automaticamente

#### JVM

- `jvm_memory_used_bytes`
- `jvm_memory_max_bytes`
- `jvm_gc_pause_seconds_sum`
- `jvm_gc_pause_seconds_count`
- `jvm_threads_live_threads`

#### HTTP

- `http_server_requests_seconds_count`
- `http_server_requests_seconds_sum`
- `http_server_requests_seconds_bucket`
- métricas por `method`, `uri`, `status`, `exception`

#### Processo

- `process_cpu_usage`
- `process_start_time_seconds`
- `system_cpu_usage`

### Como acessar

| Serviço | URL | Uso |
|---|---|---|
| Prometheus | http://localhost:9090 | interface de queries PromQL |
| Prometheus Targets | http://localhost:9090/targets | status de cada scrape |
| Prometheus Alertas | http://localhost:9090/alerts | alertas ativos |
| Prometheus Regras | http://localhost:9090/rules | grupos de regras |
| Grafana | http://localhost:3000 | dashboards provisionados |

### Provisioning automático

O diretório `grafana/provisioning` garante:

- datasource Prometheus criado automaticamente com `uid: prometheus`
- dashboards carregados sem configuração manual
- dashboard `01-overview.json` como homepage padrão

#### Deploy no Kubernetes (modo K8s)

Para provisionar os dashboards no Grafana instalado via Helm no namespace `fiapx`:

```bash
# 1. Criar o ConfigMap com todos os dashboards JSON
kubectl create configmap grafana-dashboards \
  --from-file=grafana/dashboards/01-overview.json \
  --from-file=grafana/dashboards/02-video-upload.json \
  --from-file=grafana/dashboards/03-video-processing.json \
  --from-file=grafana/dashboards/04-video-status.json \
  --from-file=grafana/dashboards/05-video-download.json \
  --from-file=grafana/dashboards/06-notification.json \
  -n fiapx

# 2. Atualizar o Helm release com os valores de provisioning
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade grafana grafana/grafana -n fiapx -f grafana/helm-values.yaml
```

O arquivo `grafana/helm-values.yaml` configura automaticamente:
- datasource Prometheus com `uid: prometheus`
- provider de dashboards apontando para o ConfigMap `grafana-dashboards`
- homepage padrão: `01-overview.json`

---

## 📈 Dashboards Grafana

Os seis dashboards deste repositório são válidos, versionados em Git e carregados automaticamente pelo Grafana.

### Visão geral dos dashboards

| Arquivo | UID | Objetivo |
|---|---|---|
| `01-overview.json` | `fiapx-overview` | visão consolidada de disponibilidade, tráfego, erros e heap |
| `02-video-upload.json` | `fiapx-upload` | acompanhamento detalhado do upload-service |
| `03-video-processing.json` | `fiapx-processing` | acompanhamento detalhado do processing-service |
| `04-video-status.json` | `fiapx-status` | acompanhamento detalhado do status-service |
| `05-video-download.json` | `fiapx-download` | acompanhamento detalhado do download-service |
| `06-notification.json` | `fiapx-notification` | acompanhamento detalhado do notification-service |

### 01-overview

| Linha | Painel | Métrica |
|---|---|---|
| 1 | Status `video-upload` | `up{job="video-upload-service"}` |
| 1 | Status `video-processing` | `up{job="video-processing-service"}` |
| 1 | Status `video-status` | `up{job="video-status-service"}` |
| 1 | Status `video-download` | `up{job="video-download-service"}` |
| 1 | Status `notification` | `up{job="notification-service"}` |
| 2 | Requisições/s — Todos os Serviços | `sum by (job) (rate(http_server_requests_seconds_count[1m]))` |
| 2 | Taxa de Erros 5xx | `sum by (job) (rate(http_server_requests_seconds_count{status=~"5.."}[5m])) / sum by (job) (rate(http_server_requests_seconds_count[5m])) * 100` |
| 3 | Heap JVM usado por serviço | `jvm_memory_used_bytes{area="heap"}` |

### 02 a 06 — Estrutura padrão por serviço

Cada dashboard de serviço segue a mesma estrutura:

| Linha | Painel | Tipo | Objetivo |
|---|---|---|---|
| 1 | Status | `stat` | mostrar `UP` ou `DOWN` |
| 1 | Req/s | `stat` | throughput instantâneo |
| 2 | Requisições por endpoint | `timeseries` | volume por endpoint/status |
| 2 | Latência p95 | `timeseries` | percentil 95 do tempo de resposta |
| 3 | Heap JVM | `timeseries` | uso de heap ao longo do tempo |
| 3 | Threads ativas | `timeseries` | quantidade de threads vivas |

### Métricas por dashboard de serviço

| Dashboard | Job filtrado |
|---|---|
| Upload | `video-upload-service` |
| Processing | `video-processing-service` |
| Status | `video-status-service` |
| Download | `video-download-service` |
| Notification | `notification-service` |

### Benefícios práticos

- troubleshooting rápido por microserviço
- comparação de comportamento entre serviços
- validação local antes de deploy
- detecção de regressão de latência ou memória

---

## 🚨 Alertas Configurados

As regras ficam em `prometheus/rules/` e são carregadas automaticamente pelo Prometheus.

### 1. `service_alerts.yml`

Responsável por disponibilidade e reinícios anômalos.

```yaml
groups:
  - name: service_availability
    interval: 30s
    rules:
      - alert: ServiceDown
        expr: up{job=~"video-.*-service|notification-service"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Servico {{ $labels.job }} esta fora do ar"
          description: "O servico {{ $labels.job }} nao responde ha mais de 1 minuto. Verifique o container imediatamente."

      - alert: ServiceRestarting
        expr: changes(process_start_time_seconds{job=~"video-.*-service|notification-service"}[10m]) > 2
        for: 0m
        labels:
          severity: warning
        annotations:
          summary: "Servico {{ $labels.job }} reiniciou multiplas vezes"
          description: "O servico reiniciou mais de 2 vezes nos ultimos 10 minutos — possivel crash loop."
```

**Explicação:**

- `ServiceDown`: dispara quando qualquer microserviço fica indisponível por mais de 1 minuto
- `ServiceRestarting`: identifica possível crash loop

### 2. `http_alerts.yml`

Responsável por erros HTTP, latência e heap.

```yaml
groups:
  - name: http_performance
    rules:
      - alert: HighErrorRate5xx
        expr: |
          (
            rate(http_server_requests_seconds_count{status=~"5.."}[5m])
            /
            rate(http_server_requests_seconds_count[5m])
          ) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Alta taxa de erros 5xx em {{ $labels.job }}"
          description: "Taxa de erros HTTP 5xx acima de 5% por 5 minutos no servico {{ $labels.job }}."

      - alert: HighLatencyP95
        expr: |
          histogram_quantile(0.95,
            rate(http_server_requests_seconds_bucket[5m])
          ) > 2.0
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Latencia p95 alta em {{ $labels.job }}"
          description: "Latencia p95 acima de 2 segundos por 5 minutos no servico {{ $labels.job }}."

      - alert: HighJvmHeapUsage
        expr: |
          (jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"}) > 0.85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Uso de heap JVM alto em {{ $labels.job }}"
          description: "Heap JVM acima de 85% de uso no servico {{ $labels.job }}."
```

**Explicação:**

- `HighErrorRate5xx`: taxa de erro acima de 5%
- `HighLatencyP95`: p95 acima de 2 segundos
- `HighJvmHeapUsage`: heap acima de 85%

### 3. `processing_alerts.yml`

Responsável por sintomas importantes do pipeline de vídeo.

```yaml
groups:
  - name: video_processing
    rules:
      - alert: VideoProcessingErrors
        expr: |
          rate(http_server_requests_seconds_count{
            job="video-processing-service", status=~"5.."
          }[10m]) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Alta taxa de falhas no processamento de video"
          description: "O video-processing-service esta falhando com alta frequencia. Verifique os logs."

      - alert: NotificationEmailFailures
        expr: |
          rate(http_server_requests_seconds_count{
            job="notification-service", status=~"5.."
          }[10m]) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Falhas no envio de notificacoes"
          description: "O notification-service esta com falhas. E-mails podem nao estar sendo entregues."

      - alert: HighGcPauseTime
        expr: |
          rate(jvm_gc_pause_seconds_sum[5m])
          /
          rate(jvm_gc_pause_seconds_count[5m]) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Pauses de GC elevadas em {{ $labels.job }}"
          description: "O GC esta pausando a JVM por mais de 500ms em media no servico {{ $labels.job }}."
```

**Explicação:**

- `VideoProcessingErrors`: protege o serviço mais crítico do pipeline
- `NotificationEmailFailures`: alerta problemas de comunicação com o usuário final
- `HighGcPauseTime`: antecipa degradação por pressão de memória

---

## 🔒 Proteção da Branch main

As regras abaixo seguem o padrão adotado nos demais repositórios do projeto.

| Regra | Valor |
|---|---|
| Require a pull request before merging | ✅ Ativado |
| Required approvals | 1 (desabilitado — grupo com 1 pessoa) |
| Dismiss stale reviews | ✅ Ativado |
| Require status checks to pass | ✅ Ativado |
| Require branches to be up to date | ✅ Ativado |
| Do not allow bypassing | ✅ Ativado |

### Status checks obrigatórios

| Check | Origem |
|---|---|
| `validate-yaml` | job do `validate.yml` |
| `validate-prometheus-rules` | job do `validate.yml` |

> ⚠️ O status check só aparece para seleção no GitHub após a primeira execução bem-sucedida do workflow.

---

## 🚀 Execução

A stack de observabilidade pode ser executada de dois modos:

---

### 🅰️ Modo K8s — Cluster local Docker Desktop *(recomendado)*

O Prometheus e o Grafana são provisionados **automaticamente** pelo repositório [fiap-14soat-tc-fase5-iac-terraform](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-iac-terraform) quando o script `setup-cluster.sh` é executado. Não é necessário rodar o Docker Compose deste repositório.

#### ⚙️ Pré-requisitos

- Docker Desktop 4.25+ com Kubernetes habilitado
- `kubectl` configurado com contexto `docker-desktop`
- `helm` 3.x
- `terraform` 1.x

#### ⚙️ Passos

```bash
# 1. Clone o repositório de infraestrutura
git clone https://github.com/jonasfschuh/fiap-14soat-tc-fase5-iac-terraform
cd fiap-14soat-tc-fase5-iac-terraform

# 2. Configure as variáveis
cp infra/terraform.tfvars.example infra/terraform.tfvars
# edite infra/terraform.tfvars e defina jwt_secret

# 3. Execute o script de provisionamento
bash scripts/setup-cluster.sh
```

O script provisiona automaticamente:
- Prometheus (Helm) com scrape dos 5 microserviços e regras de alerta
- Grafana (Helm) com datasource Prometheus pré-configurado

#### URLs após provisionamento K8s

| Serviço | URL | Credenciais |
|---------|-----|-------------|
| Prometheus | http://localhost:9090 | — |
| Prometheus Targets | http://localhost:9090/targets | — |
| Grafana | http://localhost:3000 | admin / admin |

---

### 🅱️ Modo Docker Compose — Desenvolvimento sem cluster

Use este modo caso não queira subir o cluster Kubernetes. Os microserviços devem estar rodando conectados à `fiap-network`.

#### ⚙️ Pré-requisitos

- Docker Desktop 4.25+
- Todos os microserviços rodando conectados à `fiap-network`

#### ⚙️ Configuração da rede Docker compartilhada

```bash
docker network create fiap-network
```

#### Opção A — Subir observabilidade após os serviços *(recomendado)*

Ordem sugerida:

```bash
cd fiap-14soat-tc-fase5-video-upload-service && docker compose up -d
cd fiap-14soat-tc-fase5-video-processing-service && docker compose up -d
cd fiap-14soat-tc-fase5-video-status-service && docker compose up -d
cd fiap-14soat-tc-fase5-video-download-service && docker compose up -d
cd fiap-14soat-tc-fase5-notification-service && docker compose up -d
cd fiap-14soat-tc-fase5-observability && docker-start-local-dev.bat
```

#### Opção B — Apenas observabilidade (serviços externos)

```bash
docker compose up -d
```

#### Scripts disponíveis

| Script | Objetivo |
|---|---|
| `docker-start-full-container.bat` | cria a rede se necessário e sobe o stack completo de observabilidade |
| `docker-start-local-dev.bat` | sobe apenas `prometheus` e `grafana` para desenvolvimento local |
| `docker-stop-services.bat` | derruba os containers mantendo os volumes |

#### URLs úteis (Docker Compose)

| Serviço | URL | Descrição |
|---|---|---|
| Prometheus | http://localhost:9090 | Interface de queries PromQL |
| Prometheus Targets | http://localhost:9090/targets | Status dos scrapes |
| Prometheus Alertas | http://localhost:9090/alerts | Regras ativas |
| Grafana | http://localhost:3000 | Dashboards (admin/admin) |

---

### Variáveis de Ambiente

| Variável | Padrão | Descrição |
|---|---|---|
| `GF_SECURITY_ADMIN_USER` | `admin` | Usuário admin do Grafana |
| `GF_SECURITY_ADMIN_PASSWORD` | `admin` | Senha admin do Grafana |
| `NEW_RELIC_LICENSE_KEY` | `(arquivo .env)` | License key do New Relic (opcional) |

### Persistência (Docker Compose)

Os dados ficam salvos em volumes Docker:

- `prometheus-data`
- `grafana-data`

Para remover o histórico:

```bash
docker compose down -v
```

---

## 🔗 Repositórios Relacionados

| Ordem | Repositório | Descrição               |
|---|---|-------------------------|
| 1 | [fiap-14soat-tc-fase5-iac-terraform](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-iac-terraform) | Infraestrutura K8s local — banco de dados, RabbitMQ, Prometheus, Grafana |
| 2 | [fiap-14soat-tc-fase5-auth](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-auth) | Login Authorizer            |
| 3 | [fiap-14soat-tc-fase5-video-upload-service](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-video-upload-service) | Upload + RabbitMQ publisher |
| 4 | [fiap-14soat-tc-fase5-video-processing-service](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-video-processing-service) | Processa vídeo, extrai frames, gera ZIP |
| 5 | [fiap-14soat-tc-fase5-video-status-service](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-video-status-service) | Status e metadados dos vídeos por usuário |
| 6 | [fiap-14soat-tc-fase5-video-download-service](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-video-download-service) | Download do ZIP via URL local |
| 7 | [fiap-14soat-tc-fase5-notification-service](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-notification-service) | Notificação por e-mail em caso de erro/conclusão |
| 8 | [fiap-14soat-tc-fase5-observability](https://github.com/jonasfschuh/fiap-14soat-tc-fase5-observability) | Prometheus + Grafana — dashboards e alertas |

---

<div align="center">
**🎓 Desenvolvido para o Tech Challenge FIAP 14SOAT — Fase 5 (Hackathon)**
*Projeto Acadêmico — Pós-Graduação em Arquitetura de Software · FIAP 2025/2026*
[⬆ Voltar ao topo](#fiap-14soat-tc-fase5-observability)
</div>
