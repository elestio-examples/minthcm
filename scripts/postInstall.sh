#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."

if [ -e "./initialized" ]; then
    echo "Already initialized, skipping..."
    sleep 30s;
else
    docker-compose down -v --remove-orphans;

    rm -rf ./minthcm_www;
    rm -rf ./minthcm_cron;
    rm -rf ./minthcm_db;
    rm -rf ./minthcm_es;

    mkdir -p ./minthcm_www;
    mkdir -p ./minthcm_cron;
    mkdir -p ./minthcm_db;
    mkdir -p ./minthcm_es;
    chown -R 1000:1000 ./minthcm_www;
    chown -R 1000:1000 ./minthcm_cron;
    chown -R 1000:1000 ./minthcm_db;
    chown -R 1000:1000 ./minthcm_es;

    chmod -R 777 ./minthcm_www
    chmod -R 777 ./minthcm_cron
    chmod -R 777 ./minthcm_db
    chmod -R 777 ./minthcm_es

    docker-compose up -d minthcm-es;

    sleep 60s;

    docker-compose up -d;

    sleep 120s;


    docker-compose exec -T minthcm-db bash -c "mysql -u root -p'${MYSQL_PASSWORD}' -e \"USE minthcm; UPDATE outbound_email SET smtp_from_name='MintHCM', smtp_from_addr='${SMTP_FROM}', mail_smtpserver='${SMTP_HOSTS}', mail_smtpport='${SMTP_PORT}', mail_smtpauth_req='0' WHERE mail_sendtype='SMTP';\""
    
    docker-compose exec -T minthcm-db bash -c "mysql -u root -p'${MYSQL_PASSWORD}' -e \"USE minthcm; UPDATE config SET value='${SMTP_FROM}' WHERE name='fromaddress';\""

    touch "./initialized"
fi