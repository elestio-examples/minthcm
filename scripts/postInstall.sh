#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."

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

docker-compose up -d minthcm-es;

sleep 60s;

docker-compose up -d;

sleep 120s;


docker-compose exec -T minthcm-db bash -c "mysql -u root -p'${MYSQL_PASSWORD}' -e \"USE minthcm; UPDATE outbound_email SET smtp_from_name='MintHCM', smtp_from_addr='${SMTP_FROM}', mail_smtpserver='${SMTP_HOSTS}', mail_smtpport='${SMTP_PORT}' WHERE mail_sendtype='SMTP';\""

