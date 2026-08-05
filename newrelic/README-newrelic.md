# New Relic — Guia de Observabilidade da Plataforma FIAP X

## 1. O que o New Relic já monitora

Todos os cinco microserviços Java Spring Boot da plataforma FIAP X já possuem o **New Relic Java Agent** instalado e configurado com `newrelic.yml`. Isso significa que, assim que a variável `NEW_RELIC_LICENSE_KEY` apontar para uma conta válida, o agente passa a enviar telemetria automaticamente para a plataforma.

### Itens monitorados automaticamente

| Recurso | O que o New Relic coleta |
|---|---|
| **APM** | throughput, tempo de resposta, Apdex, taxa de erro, transações mais lentas |
| **Distributed Tracing** | rastreamento ponta a ponta entre chamadas HTTP, filas, integrações e processamento assíncrono |
| **Logs in Context** | correlação de logs com traces e transações do APM |
| **JVM** | heap, non-heap, garbage collection, threads, classes carregadas |
| **HTTP / Spring Boot** | endpoints, método HTTP, status code, duração, erros 4xx/5xx |
| **SQS / Mensageria** | publicação e consumo de mensagens, tempo gasto nas integrações instrumentadas |

### Cobertura esperada por serviço

| Serviço | App name no New Relic | Cobertura principal |
|---|---|---|
| `video-upload-service` | `video-upload-ms` | upload HTTP, persistência, envio para SQS `video-uploaded` |
| `video-processing-service` | `video-processing-ms` | consumo da fila, execução do ffmpeg, geração de ZIP, integrações S3/SQS |
| `video-status-service` | `video-status-ms` | consultas e atualização de status por vídeo/usuário |
| `video-download-service` | `video-download-ms` | geração de presigned URL, validações e respostas HTTP |
| `notification-service` | `notification-ms` | consumo de eventos, processamento e envio de e-mails |

---

## 2. Como criar conta gratuita

O New Relic possui plano gratuito com franquia suficiente para ambientes acadêmicos e de laboratório.

### Passos

1. Acesse: [https://newrelic.com/signup](https://newrelic.com/signup)
2. Crie sua conta com e-mail e senha.
3. Confirme o cadastro pelo e-mail enviado.
4. Após o login, acesse o painel principal da plataforma.

### Free tier

- **100 GB/mês** de ingestão gratuita
- Acesso a APM, traces, dashboards, consultas e alertas
- Ideal para desenvolvimento local, demonstrações e validação do hackathon

> Observação: os limites comerciais podem mudar ao longo do tempo. Sempre valide a franquia vigente diretamente na documentação comercial do New Relic.

---

## 3. Como obter a License Key

Depois de criar a conta, a chave de ingestão deve ser copiada do painel:

1. Entre no New Relic.
2. Abra **Settings**.
3. Vá em **API Keys**.
4. Localize a chave do tipo **Ingest - License**.
5. Copie o valor da chave.

Essa é a chave que o Java Agent usa para enviar dados para a sua conta.

---

## 4. Como configurar na plataforma FIAP X

O projeto já está preparado para usar o New Relic. Em cada microserviço existe um arquivo `.env` com a variável:

```env
NEW_RELIC_LICENSE_KEY=b825897cd9ec303bb173805339b7d7839d09NRAL
```

### O que fazer

1. Abra o `.env` de cada repositório de microserviço.
2. Substitua o valor de `NEW_RELIC_LICENSE_KEY` pela chave da sua conta.
3. Reinicie os containers ou a aplicação Spring Boot.

### Importante

- O mesmo valor pode ser usado em todos os cinco serviços.
- Não é necessário alterar o código Java.
- Não é necessário reinstalar o agente.
- O arquivo `newrelic.yml` já existe nos serviços.

---

## 5. Estrutura do `newrelic.yml` explicada

O arquivo `newrelic.yml` define como o agente Java se identifica e quais recursos ficam ativos.

### Campos principais

| Campo | Função |
|---|---|
| `license_key` | chave que autentica o envio da telemetria para a conta New Relic |
| `app_name` | nome da aplicação exibido no APM |
| `distributed_tracing.enabled` | habilita rastreamento ponta a ponta |
| `application_logging.enabled` | habilita captura/correlação de logs |
| `application_logging.forwarding.enabled` | envia logs automaticamente para a plataforma |
| `application_logging.metrics.enabled` | gera métricas derivadas dos logs |
| `transaction_tracer.enabled` | captura traces detalhados de transações lentas |
| `error_collector.enabled` | registra exceções e erros de aplicação |
| `jvm_metrics.enabled` | coleta heap, GC, threads e demais métricas da JVM |

### Exemplo conceitual

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

### Resultado esperado

Com essa estrutura, o New Relic passa a mostrar:

- throughput por minuto
- latência média e percentis
- taxa de erro
- traces de chamadas HTTP
- consumo de heap e pausas de GC
- correlação entre logs e transações

---

## 6. App names configurados por serviço

Os nomes padronizados das aplicações são:

| Serviço | App name |
|---|---|
| Video Upload | `video-upload-ms` |
| Video Processing | `video-processing-ms` |
| Video Status | `video-status-ms` |
| Video Download | `video-download-ms` |
| Notification | `notification-ms` |

Esses nomes devem ser mantidos para facilitar:

- comparação entre ambientes
- criação de dashboards por serviço
- filtros em traces distribuídos
- criação de alertas segmentados

---

## 7. Distributed Tracing — fluxo completo

O New Relic permite rastrear o fluxo de negócio do upload ao desfecho da notificação.

### Fluxo ponta a ponta

```text
POST /api/videos
  → persistência do upload
  → SQS: video-uploaded
  → video-processing-service
  → ffmpeg
  → upload do ZIP no S3
  → SQS: video-events
  → video-status-service
  → atualização de status
  → notification-service
  → envio de e-mail
```

### O que observar no trace

| Etapa | Sinal esperado |
|---|---|
| `POST /api/videos` | transação web no `video-upload-ms` |
| `SQS: video-uploaded` | segmento de mensageria entre upload e processamento |
| `ffmpeg` | aumento no tempo de resposta e no consumo de CPU/GC do `video-processing-ms` |
| `S3` | integração externa associada ao processamento ou download |
| `SQS: video-events` | novo salto assíncrono para atualização de status/notificação |
| `status update` | transação da API ou consumidor no `video-status-ms` |
| `email` | operação final registrada no `notification-ms` |

### Benefícios

- identificar gargalos por etapa
- localizar falhas em fluxos assíncronos
- entender impacto de filas, storage e processamento pesado
- medir o tempo total de negócio do upload até a entrega

---

## 8. Como criar alertas no New Relic

Os alertas recomendados para a plataforma são:

| Alerta | Regra sugerida | Severidade |
|---|---|---|
| **Apdex baixo** | `Apdex < 0.8` | warning |
| **Taxa de erro alta** | `Error rate > 5%` | critical |
| **Heap JVM alta** | `JVM heap > 85%` | warning |
| **Tempo de resposta alto** | `Response time > 2s` | warning |

### Passo a passo

1. Acesse **Alerts & AI**.
2. Clique em **Policies** e crie uma policy para a FIAP X.
3. Adicione uma condição do tipo **APM** ou **NRQL**.
4. Selecione a aplicação desejada.
5. Defina o limiar, janela de avaliação e canais de notificação.

### Exemplos de uso

- `video-processing-ms` com `Response time > 2s` para detectar lentidão no ffmpeg
- `notification-ms` com `Error rate > 5%` para detectar falha no envio de e-mail
- `video-upload-ms` com `Apdex < 0.8` para degradação percebida no upload
- qualquer serviço com `JVM heap > 85%` para antecipar pressão de memória

---

## 9. Diferença entre New Relic e Prometheus + Grafana

As duas abordagens se complementam no projeto.

| Plataforma | Ambiente principal | Objetivo |
|---|---|---|
| **New Relic** | Produção AWS | APM completo, distributed tracing, logs, visão gerenciada e alertas corporativos |
| **Prometheus + Grafana** | Desenvolvimento local via Docker | coleta local de métricas técnicas, dashboards versionados e troubleshooting rápido |

### New Relic

- melhor para produção em AWS
- já acompanha o processo Java por agente
- correlação nativa entre APM, traces e logs
- ótima experiência para análise de incidentes reais

### Prometheus + Grafana

- ideal para laboratório local e validação do hackathon
- dashboards como código dentro do Git
- independência de conta externa
- fácil ajuste de regras e consultas PromQL

### Resumo prático

- **Produção AWS:** priorize **New Relic**
- **Ambiente local Docker:** priorize **Prometheus + Grafana**
- **Projeto FIAP X:** use ambos de forma complementar
