# BlueGuide 🌊

**BlueGuide** is a coastal knowledge platform designed specifically for Indian coastal communities. It provides essential information about fishing, marine safety, weather patterns, and government schemes through an intelligent AI-powered chat interface that works both online and offline.

## 📖 Overview

BlueGuide serves as a digital assistant for fishermen and coastal communities, offering:
- **Offline-First Design**: Access critical information even without internet connectivity
- **AI-Powered Assistance**: Intelligent chat interface for natural language queries
- **Community Contributions**: Users can contribute and share local coastal knowledge
- **Safety Alerts**: Real-time safety checks and warnings
- **Multi-Language Support**: Tailored for Indian coastal communities

## ✨ Key Features

### 🤖 Intelligent Chat Interface
- Natural language processing for user queries
- Context-aware responses about coastal topics
- Dual-mode operation (offline and online AI)

### 📚 Comprehensive Knowledge Base
- Fishing zones and techniques
- Weather patterns and signs
- Marine safety guidelines
- Government schemes and benefits
- Local coastal wisdom

### 🔒 Offline-First Architecture
- Local Hive database for offline access
- Automatic sync when online
- No internet required for core functionality

### 🤝 Community Contribution System
- Users can contribute local knowledge
- Admin approval workflow via web panel
- Verification and confidence scoring
- Firebase-powered cloud storage

### 🎯 Additional Features
- User authentication and profiles
- Contribution history tracking
- Rewards system for contributors
- Chat history management
- Dark/Light theme support
- Connectivity-aware operations

## 🛠️ Technology Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **Provider** - State management
- **Material Design** - UI components

### Storage & Database
- **Hive** - Local NoSQL database for offline storage
- **Firebase Firestore** - Cloud database for contributions
- **Firebase Core** - Backend infrastructure

### Networking
- **HTTP** - REST API communication
- **Connectivity Plus** - Network status monitoring

### Other Tools
- **Intl** - Internationalization support
- **Build Runner & Hive Generator** - Code generation

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase account (for cloud features)

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mr-Ithban/BlueGuide.git
   cd BlueGuide
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Firestore Database in your Firebase project
   - Download configuration files:
     - `google-services.json` for Android → Place in `android/app/`
     - `GoogleService-Info.plist` for iOS → Place in `ios/Runner/`
   - Update `lib/config/firebase_config.dart` with your Firebase credentials:
     ```dart
     class FirebaseConfig {
       static const String apiKey = 'your-api-key';
       static const String authDomain = 'your-project.firebaseapp.com';
       static const String projectId = 'your-project-id';
       static const String storageBucket = 'your-project.appspot.com';
       static const String messagingSenderId = 'your-sender-id';
       static const String appId = 'your-app-id';
       static const String measurementId = 'your-measurement-id';
     }
     ```
   - See [Firebase Flutter Setup Guide](https://firebase.google.com/docs/flutter/setup) for detailed instructions

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

### For End Users
1. **Launch the app** - Start BlueGuide on your device
2. **Ask questions** - Type queries about fishing, weather, safety, or schemes
3. **View history** - Access your previous conversations
4. **Contribute knowledge** - Share local wisdom with the community
5. **Earn rewards** - Get recognized for valuable contributions

### For Administrators
1. **Open admin panel** - Access `admin_panel.html` in a web browser
2. **Review contributions** - Check pending community submissions
3. **Approve/Reject** - Verify and approve quality content
4. **Manage knowledge base** - Maintain the system's information quality

## 📁 Project Structure

```
lib/
├── config/          # Firebase and app configuration
├── data/            # Data layer and repositories
├── models/          # Data models (CoastalKnowledge, UserProfile, etc.)
├── providers/       # State management (Auth, Connectivity, Theme)
├── screens/         # UI screens (Chat, Profile, Contributions, etc.)
├── services/        # Business logic (DecisionEngine, AI services, Hive)
├── theme/           # App theming and styles
├── widgets/         # Reusable UI components
└── main.dart        # App entry point

assets/
├── data/            # JSON knowledge base files
└── images/          # Image assets

admin_panel.html     # Web-based admin interface
```

## 🧩 Key Components

### Decision Engine
The brain of BlueGuide that routes queries through:
1. **Safety Layer** - Checks for emergency situations
2. **Online AI** - Uses cloud AI when connected
3. **Offline Database** - Falls back to local knowledge

### Services
- **OfflineAIService** - Local knowledge base queries
- **OnlineAIService** - Cloud-based AI responses
- **SafetyService** - Emergency detection and alerts
- **HiveService** - Local database management

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Contribution Guidelines
- Follow Flutter best practices
- Write clear commit messages
- Test your changes thoroughly
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Coastal communities of India for their invaluable local knowledge
- Flutter and Firebase teams for excellent frameworks
- All contributors who help make BlueGuide better

## 📞 Contact & Support

For questions, suggestions, or support:
- Create an issue on GitHub
- Contact the maintainers through the repository

---

**Made with ❤️ for India's coastal communities**
