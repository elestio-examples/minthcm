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


