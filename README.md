# Grape 🍷

Une application Flutter pour explorer et découvrir des vins rouges avec des fonctionnalités de géolocalisation, recherche intelligente et authentification.

## 📋 Table des matières

- [Fonctionnalités](#Fonctionnalités)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Variables d'environnement (.env)](#variables-denvironnement-env)
- [Build & Déploiement](#build--déploiement)
- [Commit Format](#commit-format)

## ✨ Fonctionnalités

### Core Features
- 🍷 **Catalogue de vins** : Affichage des vins rouges avec détails (domaine, localisation, note)
- 🔍 **Recherche** : Filtrage par nom, domaine ou localisation
- 📍 **Géolocalisation** : Affichage des vins de votre région
- 🗺️ **Carte interactive** : Visualisation des vins sur une carte avec clustering
- 🔐 **Authentification** : Connexion via Firebase Auth
- 👤 **Profil utilisateur** : Gestion du profil et paramètres

### Technical Features
- 🎯 **Caching intelligent** : Les données sont chargées une seule fois et gardées en mémoire
- ⚡ **State Management** : Riverpod pour la gestion réactive de l'état
- 🌐 **API Integration** : Connexion à l'API SampleAPIs pour les données de vins
- 🤖 **AI Integration** : Support Google Generative AI (Gemini) pour suggestions intelligentes
- 📦 **Local Storage** : SharedPreferences pour les données persistantes utilisateur
- 🛡️ **Error Handling** : Gestion d'erreur réseau avec fallback


## 📋 Pré-requis

- **Flutter** : Version ^3.8.1
- **Dart** : Inclus avec Flutter
- **Android** : SDK 21+ (pour Android)
- **iOS** : iOS 12+ (pour iOS)
- **Firebase Project** : Configuré avec Auth activée
- **Google Cloud** : Pour Google Sign-In et AI (optionnel)


## 🚀 Installation

### 1. Cloner le repository

```bash
git clone https://github.com/nonocro/grape.git
cd grape
```

### 2. Installer les dépendances

```bash
flutter pub get
```


### 3. Lancer l'application

```bash
flutter run
```

## ⚙️ Configuration

### Variables d'environnement (.env)

Le fichier `.env` est **requis** pour que l'app fonctionne.


#### Setup initial

1. **Copier le fichier exemple** :
```bash
cp .env.example .env
```

2. **Remplir les variables** :
```bash
# API & Services
GEMINI_AI_TOKEN=votre_token_gemini_ici
USE_AI=false
```

#### Variables disponibles

| Variable | Description | Exemple | Obligatoire |
|----------|-------------|---------|------------|
| `GEMINI_AI_TOKEN` | Token pour l'API Google Generative AI (Gemini) | `AIzaSy...` | ❌ Non (si USE_AI=false) |
| `USE_AI` | Activer/désactiver les features IA | `true` ou `false` | ✅ Oui |

#### Exemple de .env complet

```bash
# Google Generative AI Configuration
GEMINI_AI_TOKEN=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Feature Flags
USE_AI=false
```


## 📱 API & Services

### API Vins (SampleAPIs)
- **Endpoint** : `https://api.sampleapis.com/wines/reds`
- **Type** : REST API publique
- **Timeout** : 10 secondes
- **Fallback** : Wine par défaut en cas d'erreur

### Google Generative AI (Optionnel)
- **Service** : Gemini API
- **Configuration** : Via `GEMINI_AI_TOKEN` dans `.env`
- **Feature Flag** : `USE_AI`

### Firebase Services
- **Authentication** : Email/Password, Google Sign-In
- **Database** : Firestore (structuré pour les futures extensions)
- **Storage** : Pour stocker les images utilisateur

## 📚 Ressources utiles

- [Documentation Flutter](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Map Documentation](https://github.com/fleaflet/flutter_map)
- [Google Sign-In Plugin](https://pub.dev/packages/google_sign_in)
