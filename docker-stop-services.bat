@echo off
echo ============================================
echo  Parando Servicos de Observabilidade
echo ============================================

docker-compose down

echo.
echo  Servicos parados e removidos.
echo  Os dados do Prometheus e Grafana foram preservados nos volumes.
echo.
echo  Para remover volumes (apagar historico de metricas):
echo    docker-compose down -v
echo.
