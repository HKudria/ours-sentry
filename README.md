#Sentry

For build project run in wsl `sh build.sh`
if database doesn't setup then go inside postgres container and run script manually
`docker exec -it sentry-postgres bash -> cd var/backup -> sh restore.sh`
then restart all container `docker-compose up -d`

Sentry available on port 9000
[Sentry link](http://localhost:9000)