# Monitoramento do Servidor Nginx

Este projeto consiste em um script para monitorar o status do servidor Nginx. O script verifica se o Nginx está rodando e acessível via HTTP, registrando o resultado em logs e atualizando um arquivo de status.

## Funcionalidades

- Verifica se o Nginx está rodando.
- Verifica se a página de status do Nginx está acessível.
- Gera logs para os estados "ONLINE" e "OFFLINE".
- Atualiza um arquivo de status a cada 5 minutos.

## Requisitos

- Linux (preferencialmente em um ambiente WSL)
- Nginx instalado
- `curl` instalado
- `cron` instalado e em execução
- Acesso ao terminal

## Instalação

1. Clone este repositório:
   ```bash
   git clone https://github.com/leokillaz/Nginx-Monitor.git
   cd nginx_monitor

Torne o script executável:
```bash
  chmod +x check_nginx.sh
```

## Uso
1. Iniciar o Nginx:
```bash
  sudo service nginx start
```
2. Execute o script manualmente:
```bash
  ./check_nginx.sh
```
3. Para automatizar a execução a cada 5 minutos, adicione uma entrada no crontab:
```bash
  crontab -e
```
Adicione a seguinte linha:
```bash
  */5 * * * * /caminho/para/seu/script/check_nginx.sh
```
4. Iniciar o cron
```bash
  sudo service cron start
```
Verificar se está funcionando corretamente:
```bash
sudo service cron status
```
 5. Verificação no terminal:
 ```bash
 cat ~/nginx_monitor/status.txt
 ```
Verificação de log:

**Online:** 

 `cat ~/nginx_monitor/logs/nginx_online_$(date +"%Y%m%d").log`

**Offline:**

`cat ~/nginx_monitor/logs/nginx_offline_$(date +"%Y%m%d").log`

**Verificar em tempo real:**

`tail -f ~/nginx_monitor/logs/nginx_online_$(date +"%Y%m%d").log` 

6. Encerrar Monitoramento do Servidor Nginx:
 ```bash
 sudo service nginx stop
 ```


## Contribuições

Sinta-se à vontade para contribuir com melhorias ou correções. Faça um fork do repositório e envie um pull request.

## Autores

- [@leokillaz](https://www.github.com/leokillaz)


