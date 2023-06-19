docker compose up --build -d

sleep 5

winpty docker exec -it pos-restpie psql -U tm -d tmdb -c 'create extension "uuid-ossp"'

sleep 1

winpty docker exec -it restpie-dev bash -l -c 'python /app/scripts/dbmigrate.py'