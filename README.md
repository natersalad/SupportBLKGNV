# SupportBLKGNV

![Flutter](https://img.shields.io/badge/flutter-3.7%2B-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/firebase-Cloud-orange?logo=firebase)
![License](https://img.shields.io/badge/license-GNU-green)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey)

> **SupportBLKGNV** is a cross-platform mobile application built with **Flutter** and **Firebase** that empowers Gainesville’s Black community to connect, discover Black-owned businesses, and measure collective economic impact.  

---  
## ✨ Features
- **Authentication** – Secure email / password sign-in (social log-ins coming soon).  
- **Community Feed** – Post updates, photos, and comment/like in real time.  
- **Business Directory** – Browse, filter, and geo-locate Gainesville’s Black-owned businesses.  
- **Community Impact** – Dashboards that visualize collective spending and goal progress.  
- **User Profiles** – Follow/unfollow, personal or business account types.  
- **Community Goals** – Set, fund, and track economic goals together.  

## 🧰 Tech Stack
| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.7 + |
| Backend-as-a-Service | Firebase Auth · Cloud Firestore · Firebase Storage |
| State Management | Provider (MVVM) |
| Mapping | Google Maps Flutter |
| Charts | fl_chart |
| CI | GitHub Actions (template `.github/workflows/`) |

## 🖼 Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/2dd78bc5-2325-4938-9525-16e72a89c12f" alt="Screenshot 1" width="30%" />
  <img src="https://github.com/user-attachments/assets/ae11b538-8e69-4598-a0ef-ed03ba3e0f49" alt="Screenshot 2" width="30%" />
  <img src="https://github.com/user-attachments/assets/c459a322-bc19-4b6e-ac79-d71bd28457e9" alt="Screenshot 3" width="30%" />
</p>

## 🛠 Prerequisites
- **Flutter SDK** v3.7.0 + [Setup Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (bundled with Flutter)
- **Git**
- **Firebase** account
- **Xcode 14** + (for iOS)
- **Android Studio / SDK 34** + (for Android)
- **VS Code** or Android Studio (recommended editor)

Run `flutter doctor` to verify your tool-chain.

## 🚀 Getting Started

```bash
# 1 Clone
git clone https://github.com/natersalad/SupportBLKGNV.git
cd SupportBLKGNV/supportblkgnv

# 2 Install dependencies
flutter pub get
```
### 🔥 Firebase Setup

1. Go to Firebase Console and create a new project:
    https://console.firebase.google.com/

2. Enable Firebase Authentication (Email/Password):
    In Firebase Console:
    → Authentication > Sign-in method > Enable "Email/Password"

 3. Create Cloud Firestore in test mode:
    → Firestore Database > Create database > Start in test mode

 4. Register your app(s) with Firebase and download config files:

#### ----- Android Setup -----
 - In Firebase Console:
   - Project Settings > Add App > Android
   - Register app with your Android package name (e.g. com.example.supportblkgnv)
   - Download google-services.json
   - Place it in: android/app/google-services.json

#### ----- iOS Setup -----
 - In Firebase Console:
   - Project Settings > Add App > iOS
   - Register with your iOS bundle ID (e.g. com.example.supportblkgnv)
   - Download GoogleService-Info.plist
   - Open ios/Runner.xcworkspace in Xcode
   - Drag the .plist into the Runner target (under Supporting Files)

 In ios/Podfile, ensure your platform target is at least 14.0:
 platform :ios, '14.0'

 Run CocoaPods to install dependencies:
```
cd ios && pod install && cd ..
```
### 🌱 Environment Configuration (.env)

1. Install flutter_dotenv if not already installed
flutter pub add flutter_dotenv

2. Create a file named `.env` in the root of your Flutter project

3. Paste the following into `.env` (replace with your actual values):
```
FIREBASE_API_KEY_ANDROID=your_android_api_key
FIREBASE_APP_ID_ANDROID=your_android_app_id
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_PROJECT_ID=supportblkgnv
FIREBASE_STORAGE_BUCKET=supportblkgnv.appspot.com

FIREBASE_API_KEY_IOS=your_ios_api_key
FIREBASE_APP_ID_IOS=your_ios_app_id
FIREBASE_IOS_BUNDLE_ID=com.example.supportblkgnv
```
4. Add the `.env` file to `.gitignore` to keep it secure

5. In your `main.dart`, load the env variables at app start:
``` dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
```
6. Access variables anywhere in your app:
``` dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['FIREBASE_API_KEY_ANDROID'];
```
### ▶️ Running Locally

Run Flutter's toolchain check to verify everything is set up:
```
flutter doctor
```
Install dependencies (run from your project root):
```
flutter pub get
```
Then launch the app on your preferred platform:

#### 🚀 Android
```
flutter run -d android
```
#### 🍏 iOS
(Make sure you've opened ios/Runner.xcworkspace in Xcode at least once)
```
flutter run -d ios
```
#### 🌐 Web (Chrome)
```
flutter run -d chrome
```
### 🧪 Dev Mode & Demo Account
Set _devMode = true in service files to use mock data without hitting Firebase.
```
email: demo@supportblkgnv.com
password: password123
```

### 🤝 Contributing
#### Fork & clone your fork
```
git clone https://github.com/<your-fork>/SupportBLKGNV.git
cd SupportBLKGNV/supportblkgnv
git checkout -b feature/amazing-idea
```
#### Make changes…
```
git commit -m "feat: add amazing idea"
git push origin feature/amazing-idea
```
#### Then open a Pull Request

### 📜 License
Distributed under the GNU General Public License. See LICENSE for details.

### 👥 Authors
#### Nathan Wand
- Role: Project Manager · Full-stack Developer
- Focused on cross-platform integration, architecture, and delivery
- Portfolio: https://nathanwand.com
- Fun Fact: Aspiring indie game developer + AWS SDE @ Amazon

#### Nicolas Lopera
- Role: Backend Lead · Firebase & API Integrator
- Built and optimized the entire backend and database systems
- Current: Software Engineer @ Meta
- Interests: Safety pipelines for LLMs, NYC tech ecosystem

#### Jeffrey Drew
- Role: Frontend Lead · UI/UX Designer + Flutter Dev
- Created seamless UI, handled state, design, and optimization
- Background: Computer Science + Economics + Legal Tech
- Dream: Launch an AI-driven legal startup, then law school

## 🙏 Acknowledgements

- **Ashlei & Malcolm** – Visionaries behind the project who shaped its mission and provided deep community insight  
- **Dr. Thomas** – Faculty advisor whose support and mentorship guided our process from start to finish  
- The **Flutter** and **Firebase** open-source communities – For tools, packages, documentation, and inspiration  
- **You** – For supporting, exploring, or contributing to SupportBLKGNV ♥
