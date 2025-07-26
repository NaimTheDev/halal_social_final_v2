# 🕌 Halal Social - Islamic Mentorship Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)](https://flutter.dev/multi-platform)

A comprehensive Islamic mentorship platform built with Flutter, connecting mentees with experienced mentors in a halal, value-driven environment. This app facilitates meaningful relationships between Muslims seeking guidance and those equipped to provide it, all while maintaining Islamic principles and fostering community growth.

## 🌟 Vision Statement

**"Empowering the Ummah through Knowledge and Guidance"**

Halal Social is dedicated to creating a safe, Islamic-compliant platform where Muslims can connect for mentorship, guidance, and personal growth. We believe in the Islamic principle that seeking knowledge is an obligation for every Muslim, and our platform facilitates this sacred journey by connecting learners with knowledgeable mentors who embody Islamic values.

## 📱 App Screenshots

### 🏠 Home Dashboard
*Main navigation and dashboard overview*


<img width="547" height="886" alt="Screenshot 2025-07-13 at 10 52 31 AM" src="https://github.com/user-attachments/assets/08690aa7-299f-4519-9715-64912ca74f3c" />


### 👥 Browse Mentors  
*Discover and filter mentors by expertise and categories*

<img width="550" height="883" alt="Screenshot 2025-07-13 at 10 53 13 AM" src="https://github.com/user-attachments/assets/21a81dab-5363-4b8d-9a0d-07556785e1e7" />


### 💬 Chat Interface
*Real-time messaging between mentors and mentees*

<img width="548" height="891" alt="Screenshot 2025-07-13 at 10 52 50 AM" src="https://github.com/user-attachments/assets/602ffa79-bff0-4c4a-89c0-886aeb8b8cea" />


### ⚙️ User Settings
*Profile management and app configuration*

<img width="544" height="888" alt="Screenshot 2025-07-13 at 10 52 40 AM" src="https://github.com/user-attachments/assets/7e03ca9c-2b24-40fb-bba1-980edee64196" />


## ✨ Key Features

### 🔍 **Mentor Discovery**
- **Category-based browsing**: Find mentors by Islamic studies, career guidance, personal development, and more
- **Advanced search and filtering**: Search by expertise, location, language, and availability
- **Detailed mentor profiles**: View qualifications, experience, specializations, and reviews
- **Islamic specialization categories**: Quran studies, Hadith, Fiqh, Islamic finance, and spiritual guidance

### 💬 **Communication & Messaging**
- **Real-time chat system**: Secure, private messaging between mentors and mentees
- **Multimedia support**: Share documents, images, and resources
- **Message history**: Maintain conversation records for ongoing guidance
- **Islamic etiquette**: Built-in reminders for proper adab in communication

### 📅 **Session Management**
- **Calendly integration**: Seamless scheduling for video calls and meetings
- **Automated reminders**: Prayer time-aware scheduling notifications
- **Session notes**: Track progress and key discussion points
- **Flexible scheduling**: Accommodate different time zones and prayer schedules

### 👤 **User Profiles & Authentication**
- **Role-based access**: Separate interfaces for mentors and mentees
- **Comprehensive profiles**: Showcase expertise, Islamic knowledge, and experience
- **Secure authentication**: Firebase-powered login with Islamic user guidelines
- **Privacy controls**: Maintain confidentiality and appropriate interaction boundaries

### 🏷️ **Specialized Categories**
- **Islamic Studies**: Quran, Hadith, Islamic Law (Fiqh), Islamic History
- **Professional Development**: Career guidance, entrepreneurship, Islamic finance
- **Personal Growth**: Life coaching, marriage counseling, parenting in Islam
- **Education**: Academic mentoring with Islamic perspective
- **Community Service**: Dawah, charity work, community leadership

### 🛡️ **Islamic Compliance Features**
- **Gender-appropriate interactions**: Respectful communication guidelines
- **Prayer time awareness**: Scheduling that respects Islamic obligations
- **Halal content moderation**: Ensuring all interactions align with Islamic values
- **Community guidelines**: Based on Islamic principles of respect and knowledge-seeking

## 🛠️ Technology Stack

### **Frontend**
- **Flutter 3.7.2+**: Cross-platform mobile and web development
- **Dart**: Programming language for Flutter applications
- **Hooks Riverpod 2.6.1**: State management and dependency injection
- **Flutter Hooks 0.21.2**: React-like hooks for Flutter widgets

### **Backend & Services**
- **Firebase Core 3.14.0**: Backend-as-a-Service platform
- **Firebase Auth 5.6.0**: User authentication and authorization
- **Cloud Firestore 5.6.9**: NoSQL document database for real-time data
- **Firebase Storage 12.4.9**: Cloud storage for user-uploaded content
- **Cloud Functions 5.5.2**: Serverless backend logic
- **Firebase Realtime Database 11.3.9**: Real-time chat functionality

### **Integrations**
- **Calendly**: Video call scheduling and calendar management
- **WebView Flutter 4.13.0**: In-app web content rendering
- **URL Launcher 6.3.1**: External link and app launching
- **Image Picker 1.1.2**: Camera and gallery integration
- **Cached Network Image**: Optimized image loading and caching

### **Development & Utilities**
- **HTTP 1.4.0**: Network requests and API communication
- **Shared Preferences 2.5.3**: Local data persistence
- **JSON Annotation 4.9.0**: Model serialization
- **Intl 0.20.2**: Internationalization support
- **Flutter Lints 5.0.0**: Code quality and standards

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.7.2 or higher
- **Dart SDK**: Version 3.0.0 or higher
- **Firebase CLI**: For backend configuration
- **Android Studio/VS Code**: With Flutter plugins
- **Xcode**: For iOS development (macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/NaimTheDev/halal_social_final_v2.git
   cd halal_social_final_v2
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   # Install Firebase CLI if not already installed
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Configure FlutterFire
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

4. **Set up environment variables**
   ```bash
   # Create .env file for environment-specific configurations
   cp .env.example .env
   # Edit .env with your API keys and configuration
   ```

5. **Configure Calendly Integration**
   - Create a Calendly developer account
   - Generate API keys and add them to your Firebase configuration
   - Update the Calendly settings in your app configuration

6. **Run the application**
   ```bash
   # Run on debug mode
   flutter run
   
   # Build for production
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   flutter build web --release  # Web
   ```

### Firebase Setup

1. **Create a Firebase project** at [Firebase Console](https://console.firebase.google.com/)

2. **Enable required services:**
   - Authentication (Email/Password, Google Sign-in)
   - Cloud Firestore
   - Firebase Storage
   - Cloud Functions
   - Realtime Database

3. **Configure authentication providers:**
   - Enable Email/Password authentication
   - Configure OAuth providers as needed
   - Set up security rules for Islamic compliance

4. **Database structure:**
   ```
   /users/{userId}
   /mentors/{mentorId}
   /chats/{chatId}
   /messages/{messageId}
   /categories/{categoryId}
   /scheduledCalls/{callId}
   ```

## 📁 Project Structure

```
lib/
├── 📱 app/                    # App-level configuration
│   └── app_wrapper.dart       # Main app initialization
├── 🏗️ core/                   # Core functionality
│   ├── error/                 # Error handling
│   ├── navigation/            # App routing
│   ├── providers/             # Global providers
│   └── state/                 # App state management
├── 🎯 features/               # Feature modules
│   ├── 🔐 auth/              # Authentication
│   │   ├── controllers/       # Auth business logic
│   │   ├── models/           # User models
│   │   ├── providers/        # Auth providers
│   │   ├── services/         # Auth services
│   │   └── views/            # Login/signup UI
│   ├── 👥 mentors/           # Mentor management
│   │   ├── controllers/      # Mentor logic
│   │   ├── models/          # Mentor models
│   │   ├── providers/       # Mentor providers
│   │   └── views/           # Mentor browsing UI
│   ├── 💬 chats/            # Messaging system
│   │   ├── providers/       # Chat providers
│   │   ├── views/           # Chat UI
│   │   └── widgets/         # Chat components
│   ├── 📞 calls/            # Video calling
│   ├── 🏷️ categories/       # Mentor categories
│   ├── 🏠 home/             # Home dashboard
│   ├── ⚙️ settings/         # User settings
│   └── 🖼️ shell/            # App navigation shell
├── 📊 models/                # Shared data models
├── 🎨 theme/                 # App theming
├── 🔧 utils/                 # Utility functions
├── 🎯 providers/             # Global providers
├── 🎨 shared/                # Shared widgets/components
└── 🔧 services/              # External services
```

## 🌍 Platform Support

**Halal Social** is built with Flutter's cross-platform capabilities:

### 📱 **Mobile Platforms**
- **iOS 12.0+**: Native iOS experience with Cupertino design elements
- **Android 5.0+ (API 21+)**: Material Design 3 implementation
- **Responsive design**: Adapts to different screen sizes and orientations

### 🌐 **Web Platform**
- **Progressive Web App (PWA)**: Installable web experience
- **Responsive web design**: Desktop and mobile web support
- **Modern browser support**: Chrome, Firefox, Safari, Edge

### 🖥️ **Desktop Platforms**
- **Windows 10+**: Native Windows application
- **macOS 10.14+**: Native macOS experience
- **Linux**: Ubuntu LTS and other distributions

### ⚡ **Performance Optimizations**
- **Code splitting**: Efficient loading for web platforms
- **Image optimization**: Cached network images for better performance
- **State management**: Optimized Riverpod implementation
- **Firebase optimization**: Efficient database queries and caching

## 🤝 Contributing

We welcome contributions from the community to help improve Halal Social and serve the Ummah better.

### Contributing Guidelines

1. **Read our Code of Conduct**: Ensure all contributions align with Islamic values and principles

2. **Fork the repository** and create a feature branch:
   ```bash
   git checkout -b feature/amazing-islamic-feature
   ```

3. **Follow Islamic development principles:**
   - Ensure all features promote beneficial knowledge (ilm nafi)
   - Maintain halal interaction guidelines
   - Respect user privacy and Islamic ethics
   - Consider diverse Islamic perspectives and practices

4. **Code Standards:**
   - Follow Flutter/Dart conventions
   - Write comprehensive tests
   - Document Islamic-specific features
   - Ensure accessibility compliance

5. **Commit your changes:**
   ```bash
   git commit -m "feat: add beneficial Islamic feature"
   ```

6. **Push to your branch:**
   ```bash
   git push origin feature/amazing-islamic-feature
   ```

7. **Submit a Pull Request** with:
   - Clear description of changes
   - Islamic compliance considerations
   - Test coverage information
   - Screenshots for UI changes

### 🎯 **Areas for Contribution**

- **Islamic Content**: Expanding mentorship categories and Islamic resources
- **Accessibility**: Improving app accessibility for diverse users
- **Internationalization**: Adding support for Arabic and other languages
- **Performance**: Optimizing app performance and user experience
- **Documentation**: Improving developer and user documentation
- **Testing**: Expanding test coverage and quality assurance

### 🛡️ **Islamic Compliance Review**

All contributions undergo review for Islamic compliance:
- Content appropriateness
- Gender interaction guidelines
- Privacy and modesty considerations
- Cultural sensitivity
- Islamic knowledge accuracy

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support & Contact

- **Issues**: Report bugs and request features via [GitHub Issues](https://github.com/NaimTheDev/halal_social_final_v2/issues)
- **Developer**: [@NaimTheDev](https://github.com/NaimTheDev)
- **Community**: Join our discussions for Islamic app development

## 🙏 Acknowledgments

- **Allah (SWT)**: For the guidance and opportunity to serve the Ummah
- **Islamic Scholars**: For guidance on app compliance with Islamic principles
- **Flutter Team**: For the amazing cross-platform framework
- **Firebase Team**: For robust backend services
- **Open Source Community**: For the tools and libraries that make this possible
- **Beta Testers**: Muslim developers and users who helped refine the platform

---

**"And whoever seeks knowledge, Allah will ease his path to Paradise."** - *Hadith*

*Built with 💚 for the Muslim Ummah*
