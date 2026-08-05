@echo off
echo ============================================
echo  Iniciando Ambiente de Desenvolvimento
echo  Observabilidade Local
echo  Stack: fiap-observability
echo ============================================
echo.
echo  Este repositorio sobe APENAS Prometheus + Grafana.
echo  Os microservicos devem estar rodando previamente
echo  e conectados a fiap-network.
echo.
echo  Ordem recomendada de inicializacao:
echo  1. cd fiap-14soat-tc-fase5-video-upload-service ^&^& docker compose up -d
echo  2. cd fiap-14soat-tc-fase5-video-processing-service ^&^& docker compose up -d
echo  3. cd fiap-14soat-tc-fase5-video-status-service ^&^& docker compose up -d
echo  4. cd fiap-14soat-tc-fase5-video-download-service ^&^& docker compose up -d
echo  5. cd fiap-14soat-tc-fase5-notification-service ^&^& docker compose up -d
echo  6. cd fiap-14soat-tc-fase5-observability ^&^& docker-start-local-dev.bat
echo.

docker-compose up -d prometheus grafana

echo.
echo   Servicos iniciados:
echo    - Prometheus:  http://localhost:9090
echo    - Grafana:     http://localhost:3000 (admin/admin)
echo    - Targets:     http://localhost:9090/targets
echo.
echo  Aguarde ~15 segundos para o Grafana carregar os dashboards.
echo.
