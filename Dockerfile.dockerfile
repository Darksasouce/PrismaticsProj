# Utiliser une version récente de Flutter avec Dart 3.6.1
FROM ghcr.io/flutter/flutter:3.19.0

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances en premier pour optimiser le cache Docker
COPY pubspec.yaml pubspec.lock ./

# Désactiver les analytics de Flutter et Dart
RUN flutter config --no-analytics && dart --disable-analytics

# Forcer la mise à jour de Flutter et Dart
RUN flutter upgrade
RUN dart --version
RUN flutter --version

# Installer les dépendances Flutter
RUN flutter pub get

# Copier tout le projet après installation des dépendances
COPY . .

# Créer un utilisateur non-root pour éviter les warnings
RUN useradd -m flutteruser && chown -R flutteruser:flutteruser /app
USER flutteruser

# Lancer l'application Flutter
CMD ["flutter", "run"]
