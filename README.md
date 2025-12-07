# Recipe Finder App 🍳

A Flutter application that helps you discover, filter, and save recipes with offline favorites.

## 📱 Features

- **Daily Suggestion** – A fresh random meal on the home screen every launch  
- **Explore & Filter** – Browse by category (Seafood, Pasta…) or cuisine (Italian, Japanese…)  
- **Search** – Instant name-based search across the entire catalog  
- **Cooking Details** – Ingredients, measurements, and step-by-step instructions  
- **Video Tutorials** – One-tap YouTube links for visual guidance  
- **Offline Favorites** – SQLite-powered local storage keeps saved meals available without internet  
- **First-Run Onboarding** – Clean intro slides to get users started quickly  

## 🛠️ Tech Stack

| Layer                | Package / Tool                                      |
|----------------------|-----------------------------------------------------|
| Framework            | Flutter 3.x                                         |
| State Management     | Riverpod 2.x                                        |
| Navigation           | Navigator 2.0 (declarative)                         |
| Networking           | `http` + JSON serialization                         |
| Local Storage        | `sqflite` (favorites) + `shared_preferences` (flags) |
| UI Extras            | Hero animations, skeleton loaders, custom chips       |

## 🚀 Getting Started

1. Clone the repo  
   ```bash
   git clone https://github.com/your-username/recipe_finder_flutter_app.git
   cd recipe_finder_flutter_app
   ```

2. Install dependencies  
   ```bash
   flutter pub get
   ```

3. Run code generation (if models change)  
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Launch on your preferred device / emulator  
   ```bash
   flutter run
   ```

## 📂 Project Structure

```text
lib/
├── core/                  # Shared resources across the app
│   ├── constants/         # API endpoints and configuration
│   └── route/             # Route names and navigation paths
├── data/                  # Data layer handling APIs and local storage
│   ├── local/             # SQLite database implementation
│   ├── model/             # Data models (JSON parsing)
│   ├── provider/          # Riverpod state providers
│   └── service/           # HTTP calls and API logic
├── features/              # Feature-based UI organization
│   ├── screens/
│   │   ├── detail/        # Meal details view
│   │   ├── explore/       # Search and filtering screen
│   │   ├── favorite/      # Offline favorites screen
│   │   ├── home/          # Main dashboard
│   │   └── onboarding/    # Intro slides
│   └── widgets/           # Global reusable widgets (e.g., BottomNavBar)
├── app.dart               # App configuration (Theme, Routes)
└── main.dart              # Entry point