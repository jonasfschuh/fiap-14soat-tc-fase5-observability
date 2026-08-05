@echo off
echo ============================================
echo  Iniciando Observabilidade (Container)
echo  Prometheus + Grafana
echo  Stack: fiap-observability
echo ============================================
echo.
echo  PRE-REQUISITO: video-upload-service deve estar rodando
echo  (prove a fiap-network compartilhada)
echo.
echo  Criando rede fiap-network (se nao existir)...
docker network create fiap-network 2>nul

docker-compose up --build -d

echo.
echo    Servicos iniciados:
echo    - Prometheus:  http://localhost:9090
echo    - Grafana:     http://localhost:3000
echo                   Login: admin / admin
echo.
echo    Utilitarios Prometheus:
echo    - Targets:     http://localhost:9090/targets
echo    - Alertas:     http://localhost:9090/alerts
echo    - Regras:      http://localhost:9090/rules
echo.
echo    Dashboards Grafana (auto-provisionados):
echo    - Overview:    http://localhost:3000/d/fiapx-overview
echo    - Upload:      http://localhost:3000/d/fiapx-upload
echo    - Processing:  http://localhost:3000/d/fiapx-processing
echo    - Status:      http://localhost:3000/d/fiapx-status
echo    - Download:    http://localhost:3000/d/fiapx-download
echo    - Notification:http://localhost:3000/d/fiapx-notification
echo.
