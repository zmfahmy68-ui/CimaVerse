# CimaVerse  

A modern, high-performance Movie Discovery and Tracking mobile application built with **Flutter**, following the strict **MVVM (Model-View-ViewModel)** architectural pattern. The application integrates **The Movie Database (TMDB) API** for online data, **Firebase Authentication** for user accounts, and **SQFLite** for persistent offline movie list management.

---

##  Features 

- **User Authentication**: Secure sign up, login, and sign out powered by Firebase Authentication with persistent session state.
- **Movie Discovery**: Explore Popular, Top Rated, and Now Playing movies with horizontal scrolling carousels.
- **Smooth Search with Debouncing**: Real-time movie search optimized with a 500ms debounce timer and request ID tracking to eliminate keyboard lag and redundant API calls.
- **Offline Watchlists (SQFLite)**: Save and organize movies into categorized lists:
  - Favorites
  - Watched
  - Watching
  - Want to Watch
- **Dark Theme UI**: Clean, responsive cinema-focused dark design with custom gradients, splash screen, and app launcher icons.
- **Robust Error Handling**: Network retry states and validation alerts for edge cases.

---

##  Architecture & Project Structure

The project follows a clean, decoupled **MVVM + Service** architectural pattern:

```
lib/
│── model/               # Data models and JSON/Map serialization
│   └── movie.dart
│
│── service/             # Direct external communication (API, Firebase, Local DB)
│   ├── api_calling.dart
│   ├── auth_service.dart
│   ├── database_helper.dart
│   └── spref_helper.dart
│
│── Controller/          # Business logic, exception handling, data sanitization
│   ├── auth_controller.dart
│   ├── movie_controller.dart
│   └── movie_list_controller.dart
│
│── provider/            # State management via ChangeNotifier (Providers)
│   ├── auth_provider.dart
│   ├── movie_provider.dart
│   └── movie_lists_provider.dart
│
└── View/                # User Interface layer
    ├── screens/
    │   ├── splash_screen.dart
    │   ├── login_screen.dart
    │   ├── register_screen.dart
    │   ├── main_navigation_screen.dart
    │   ├── movie_home_screen.dart
    │   ├── movie_search_screen.dart
    │   ├── movie_details_screen.dart
    │   └── my_movies_list_screen.dart
    └── widgets/
        ├── movie_card.dart
        └── movie_empty_state.dart
```

### Data Flow
$$\text{Service Layer} \longrightarrow \text{Controller Layer} \longrightarrow \text{Provider Layer} \longrightarrow \text{View Layer}$$

---

##  Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking**: [Dio](https://pub.dev/packages/dio) / Http
- **Backend / Authentication**: [Firebase Core](https://pub.dev/packages/firebase_core) & [Firebase Auth](https://pub.dev/packages/firebase_auth)
- **Local Storage**: [sqflite](https://pub.dev/packages/sqflite) & [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Image Caching**: [cached_network_image](https://pub.dev/packages/cached_network_image)
- **Icon Generation**: [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

---

##  Getting Started

### Prerequisites
- Flutter SDK installed (`>=3.1.5`)
- Android Studio / VS Code
- A valid TMDB API Read Access Token

### Setup Instructions
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/cimaverse.git
   cd cimaverse
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration:**
   - Add your `google-services.json` inside the `android/app/` directory.
   - Enable **Email/Password** authentication in your Firebase Console.

4. **Run the application:**
   ```bash
   flutter run
   ```

5. **Build Release APK:**
   ```bash
   flutter build apk --release
   ```