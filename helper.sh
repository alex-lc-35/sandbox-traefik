#!/bin/bash

# Helper multi-commande pour messages-front (global, prod d'abord)

DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_COMPOSE_PROD_FILE="docker-compose.prod.yml"

show_help() {
  echo ""
  echo "🛠️  Helper Docker - messages-front (global)"
  echo ""
  echo "Commandes disponibles :"
  echo "  prod-up            → Démarrer tous les services (production)"
  echo "  prod-down          → Arrêter tous les services (production)"
  echo "  prod-destroy       → Supprimer complètement tous les conteneurs (production)"
  echo "  prod-refresh       → Rebuild + restart (production)"
  echo "  prod-restart       → Restart des services (production)"
  echo "  up                 → Démarrer tous les services (développement)"
  echo "  down               → Arrêter tous les services (développement)"
  echo "  destroy            → Supprimer complètement tous les conteneurs (développement)"
  echo "  refresh            → Rebuild + restart (développement)"
  echo "  restart            → Restart des services (développement)"
  echo "  logs-nginx         → Afficher les logs du conteneur Nginx"
}

if [ $# -lt 1 ]; then
  show_help
  exit 0
fi

COMMAND=$1
shift

# Déterminer le bon fichier Compose et le contexte (prod/dev)
if [[ "$COMMAND" == prod-* ]]; then
  FILE="$DOCKER_COMPOSE_PROD_FILE"
  CONTEXT="production"
  ACTION="${COMMAND#prod-}"
else
  FILE="$DOCKER_COMPOSE_FILE"
  CONTEXT="développement"
  ACTION="$COMMAND"
fi

case "$ACTION" in
  up)
    docker compose -f "$FILE" up -d
    ;;
  down)
    docker compose -f "$FILE" down
    ;;
  destroy)
    echo "❗ Suppression complète des services en $CONTEXT"
    docker compose -f "$FILE" down --volumes --remove-orphans
    ;;
  refresh)
    echo "🔄 Rebuild + redémarrage ($CONTEXT)"
    docker compose -f "$FILE" down
    docker compose -f "$FILE" up -d --build
    ;;
  restart)
    echo "🔄 Redémarrage ($CONTEXT)"
    docker compose -f "$FILE" restart
    ;;
  logs-nginx)
    echo "📜 Logs du conteneur messages-front-nginx"
    docker logs -f messages-front-nginx
    ;;
  *)
    echo "❌ Commande inconnue: $COMMAND"
    show_help
    exit 1
    ;;
esac
