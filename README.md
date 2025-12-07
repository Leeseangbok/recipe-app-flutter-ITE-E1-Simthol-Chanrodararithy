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
lib/
├── core/
│   ├── constants/
│   │   └── api.dart
│   └── route/
│       └── routes.dart
├── data/
│   ├── local/
│   │   └── database_helper.dart
│   ├── model/
│   │   ├── category.dart
│   │   └── meal.dart
│   ├── provider/
│   │   ├── category_provider.dart
│   │   ├── favorite_provider.dart
│   │   └── meal_provider.dart
│   └── service/
│       └── api_services.dart
├── features/
│   ├── screens/
│   │   ├── detail/
│   │   │   ├── widgets/
│   │   │   │   └── helper_chip.dart
│   │   │   └── meal_detail_screen.dart
│   │   ├── explore/
│   │   │   ├── widgets/
│   │   │   │   ├── empty.dart
│   │   │   │   ├── filtered_chip.dart
│   │   │   │   ├── meal_chip.dart
│   │   │   │   └── meta_chip.dart
│   │   │   └── explore_screen.dart
│   │   ├── favorite/
│   │   │   ├── widgets/
│   │   │   │   ├── empty.dart
│   │   │   │   ├── favorite_item.dart
│   │   │   │   └── mini_chip.dart
│   │   │   └── favorite_screen.dart
│   │   ├── home/
│   │   │   ├── widgets/
│   │   │   │   ├── card_skeleton.dart
│   │   │   │   ├── chip.dart
│   │   │   │   ├── error.dart
│   │   │   │   ├── header.dart
│   │   │   │   ├── hero_card.dart
│   │   │   │   ├── meal_card.dart
│   │   │   │   └── mini_chip.dart
│   │   │   └── home_screen.dart
│   │   └── onboarding/
│   │       └── onboarding_screen.dart
│   └── widgets/
│       └── bottom_nav.dart
├── app.dart
└── main.dart