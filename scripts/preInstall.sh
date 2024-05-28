#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./minthcm_www;
mkdir -p ./minthcm_cron;
mkdir -p ./minthcm_db;
mkdir -p ./minthcm_es;
chown -R 1000:1000 ./minthcm_www;
chown -R 1000:1000 ./minthcm_cron;
chown -R 1000:1000 ./minthcm_db;
chown -R 1000:1000 ./minthcm_es;