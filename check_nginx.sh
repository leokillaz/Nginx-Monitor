#!/bin/bash

# Define variáveis
DATE=$(date +"%d/%m/%Y")
TIME=$(date +"%H:%M")
USERNAME=$(whoami)
STATUS_URL="http://localhost/status.html"
LOG_DIR="$HOME/nginx_monitor/logs"
STATUS_FILE="$HOME/nginx_monitor/status.txt"
CRON_JOB="*/5 * * * * /bin/bash $HOME/nginx_monitor/check_nginx.sh"

# Verificação de dependências
if ! command -v curl &> /dev/null; then
    echo "Erro: curl não está instalado. Instale-o e tente novamente."
    exit 1
fi

if ! command -v nginx &> /dev/null; then
    echo "Erro: nginx não está instalado. Instale-o e tente novamente."
    exit 1
fi

# Função para verificar se o Nginx está rodando
check_nginx_process() {
    ps aux | grep -E 'nginx: master process' | grep -v grep
}

# Função para verificar se o status está online
check_nginx_status() {
    curl -s -o /dev/null -w "%{http_code}" "$STATUS_URL"
}

# Adiciona a entrada no crontab se ainda não estiver presente
(crontab -l | grep -v -F "$CRON_JOB"; echo "$CRON_JOB") | crontab -

# Verifica o status do Nginx
NGINX_PROCESS_STATUS=$(check_nginx_process)
NGINX_STATUS_CODE=$(check_nginx_status)

# Registra o status do Nginx nos logs
if [[ -z "$NGINX_PROCESS_STATUS" || "$NGINX_STATUS_CODE" -ne 200 ]]; then
    echo "$DATE $TIME - Nginx - OFFLINE - Nginx: Desativado (não rodando ou status HTML não acessível)" >> "$LOG_DIR/nginx_offline_$(date +"%Y%m%d").log"
else
    echo "$DATE $TIME - Nginx - ONLINE - Nginx: Ativado (rodando)" >> "$LOG_DIR/nginx_online_$(date +"%Y%m%d").log"
fi

# Atualiza status.txt
{
    echo "Nome de usuário: $USERNAME"
    echo "Horário atual: $TIME"
    echo "Data: $DATE"
    echo "Nginx: $(if [[ -z "$NGINX_PROCESS_STATUS" || "$NGINX_STATUS_CODE" -ne 200 ]]; then echo 'Desativado'; else echo 'Ativado'; fi)"
} > "$STATUS_FILE"

# Mensagem personalizada
if [[ -z "$NGINX_PROCESS_STATUS" || "$NGINX_STATUS_CODE" -ne 200 ]]; then
    echo "O Nginx está offline."  # Mensagem para offline
else
    echo "O Nginx está online."  # Mensagem para online
fi

