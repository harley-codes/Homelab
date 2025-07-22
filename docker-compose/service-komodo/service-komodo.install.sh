sudo chmod 600 .env
sudo chown root:root .env
sudo chmod 600 .env.merged
sudo chown root:root .env.merged
sudo cat .env .env.config > .env.merged
sudo docker compose -p service-komodo down
sudo docker compose -p service-komodo -f service-komodo.compose.yml --env-file .env.merged up -d