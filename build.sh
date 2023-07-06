cd docker
cp .env.dev .env

docker-compose run --rm sentry-base config generate-secret-key >> secret.txt
echo "generating secret key"

#check if secret key is generated
x=0
while [ $x -ne 1 ]
do
  if [ -f secret.txt ]
  then
      x=1
  else
    echo "generating secret key --> sleep 10"
    sleep 10
  fi
done
sed -i "s|^SENTRY_SECRET_KEY=.*|SENTRY_SECRET_KEY=$(sed 's/[&/\]/\\&/g' "secret.txt")|" ".env"
echo "secret key is setup"
rm secret.txt

docker-compose up -d sentry-postgres

docker cp ../backup/sentry.dump sentry-postgres:/var/backup/sentry.dump
docker exec sentry-postgres bash -c 'sh /var/backup/restore.sh'

sleep 60
docker-compose up -d

