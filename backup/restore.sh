result=$(psql -lqt -U sentry | cut -d \| -f 1 | grep -wq "sentry" && echo "true" || echo "false")
# Check the result
if [ $result != "true" ]; then
    createdb -U sentry sentry
    echo "Database 'sentry' created."
else
    echo "Database 'sentry' already exists."
fi

## If the database is empty, perform the restore
table_count=$(psql -U "sentry" -d "sentry" -t -c "SELECT count(*) FROM information_schema.tables WHERE table_catalog = 'sentry' AND table_schema = 'public';")
if [ $table_count -eq 0 ];  then
    echo "Performing restore..."
    pg_restore -U sentry -d sentry sentry.dump
    echo "Restore completed."
else
   echo "Database is not empty. No restore needed."
fi

#docker-compose run --rm sentry-base upgrade