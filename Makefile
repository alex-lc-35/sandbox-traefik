# Variables
COMPOSE=docker-compose -f docker-compose.prod.yml

# Commandes
prod-up:
	$(COMPOSE) up -d

prod-down:
	$(COMPOSE) down

prod-restart:
	$(COMPOSE) down && $(COMPOSE) up -d

prod-logs:
	$(COMPOSE) logs -f

prod-ps:
	$(COMPOSE) ps

reload-nginx:
	sudo nginx -t && sudo systemctl reload nginx
