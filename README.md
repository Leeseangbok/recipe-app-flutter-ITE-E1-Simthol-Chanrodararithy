# Recipe Finder App 🍳

A Flutter application that allows users to discover recipes, filter by category or cuisine, view detailed cooking instructions, and save their favorite meals locally.

## 📱 Features

-   **Daily Suggestion:** Get a random meal recommendation on the home screen.
-   **Explore Recipes:** Browse recipes filtered by Category (e.g., Seafood, Pasta) or Cuisine (e.g., Italian, Japanese).
-   **Search Functionality:** Find specific recipes by name.
-   **Detailed Instructions:** View ingredients, measurements, and step-by-step cooking instructions.
-   **Video Tutorials:** Direct links to YouTube cooking tutorials.
-   **Favorites:** Save recipes to your local device (using SQLite) to access them later.
-   **Onboarding:** A smooth introduction screen for first-time users.

## 🛠️ Tech Stack

-   **Framework:** [Flutter](https://flutter.dev/)
-   **State Management:** [Riverpod](https://riverpod.dev/)
-   **Navigation:** Standard Flutter Navigation
-   **Networking:** [http](https://pub.dev/packages/http)
-   **Local Storage:** [sqflite](https://pub.dev/packages/sqflite) (for saving favorites) and [shared_preferences](https://pub.dev/packages/shared_preferences) (for onboarding state).
-   **UI Components:** Custom chips, hero animations, and skeleton loading states.

## 📂 Project Structure