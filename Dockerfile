# Utilise l'image officielle Flutter
FROM cirrusci/flutter:latest

# Définit le répertoire de travail
WORKDIR /app

# Copie tout le projet Flutter
COPY . .

# Installe les dépendances
RUN flutter pub get

# Exécute l'application
CMD ["flutter", "run"]
