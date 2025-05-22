<div align="center">

# 🎵 MariBermusik Mobile Application

**A Flutter-based mobile app to learn musical instruments with ease!**

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=flutter&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-%23FFCA28.svg?style=for-the-badge&logo=firebase&logoColor=black) ![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

</div>

---

## 📖 Overview

MariBermusik is a mobile application crafted by a team of five as a college final assignment. Designed to help users learn various musical instruments, this app offers an interactive and user-friendly experience. Built with **Flutter**, it leverages **Firebase** for secure authentication, efficient database management, and insightful analytics.

---

## ✨ Features

### 1. **🎸 Home Screen with Instrument Carousel**
- A visually engaging carousel showcasing images of musical instruments with smooth animated transitions.
- **Screenshot**: 
  <table>
    <tr>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/a0251852-531e-4a25-ac4e-7f1e2f72670c" width="300" alt="Home">
      </td>
    </tr>
  </table>

### 2. **🔐 User Authentication (Login/Register)**
- Secure login and registration using email and password, featuring a modern gradient background.
- Profile creation with name and username for a personalized experience.
- **Screenshot**: 
  <table>
    <tr>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/fafeda64-7886-426b-858a-526ea7da3d73" width="300" alt="Login">
      </td>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/56ebbdfa-aca3-4a65-8f95-5a0873a3dabb" width="300" alt="Register">
      </td>
    </tr>
  </table>

### 3. **📚 Material Page**
- View, add, edit, and delete learning materials for instruments, presented in beautifully styled cards.
- Favorite materials with an intuitive heart animation for quick access.
- **Screenshot**: 
  <table>
    <tr>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/8f86b8fc-5e2b-4d12-a9bc-1c1341583865" width="300" alt="Material List">
      </td>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/31296ea8-b66a-4c7c-be50-d6eaa91b5a96" width="300" alt="Material Add">
      </td>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/ce382704-4685-44e2-be22-a182828490d3" width="300" alt="Material Edit">
      </td>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/b3328b44-eaa1-4cac-a9f8-ecb96610e55d" width="300" alt="Material Delete">
      </td>
    </tr>
  </table>

### 4. **👤 Profile Management**
- Displays user details with elegant shadow effects and editable fields.
- Update your name and sign out with a prominent, user-friendly button.
- **Screenshot**: 
  <table>
    <tr>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/6b41d368-7ec1-46fa-b6c8-e402dc6856f4" width="300" alt="Profile Guest">
      </td>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/1c78f1f1-b01b-44ca-82a3-d1d5628c9e10" width="300" alt="Profile User">
      </td>
      <td style="text-align: center">
        <img src="https://github.com/user-attachments/assets/96bdc47a-78ed-477c-975d-3ac70f0e4b4c" width="300" alt="Profile Edit">
      </td>
    </tr>
  </table>

---

## 🗂️ Project Structure

```plaintext
📦 MariBermusik
 ┣ 📂 lib
 ┃ ┣ 📂 component          # Reusable UI components
 ┃ ┃ ┣ bottom_navbar.dart
 ┃ ┃ ┣ entry_field.dart
 ┃ ┃ ┣ loading.dart
 ┃ ┃ ┣ material_card.dart
 ┃ ┃ ┣ profile_field.dart
 ┃ ┃ ┗ top_navbar.dart
 ┃ ┣ 📂 pages              # Main app screens
 ┃ ┃ ┣ home_screen.dart
 ┃ ┃ ┣ login_register.dart
 ┃ ┃ ┣ material.dart
 ┃ ┃ ┗ profile_screen.dart
 ┃ ┣ 📂 services           # Service logic
 ┃ ┃ ┣ auth.dart
 ┃ ┃ ┗ firestore.dart
 ┃ ┣ main.dart             # App entry point
 ┃ ┣ widget_tree.dart      # Manages navigation based on auth state
 ┃ ┗ firebase_options.dart # Firebase configuration
 ┣ 📂 assets
 ┃ ┗ 📂 images             # Image assets
 ┣ 📂 env                  # Environment config
 ┣ 📜 .gitattributes
 ┣ 📜 .gitignore
 ┣ 📜 metadata
 ┣ 📜 analysis_options.yaml
 ┣ 📜 firebase.json
 ┣ 📜 key_properties
 ┣ 📜 pubspec.yaml         # Dependencies
 ┣ 📜 pubspec.lock
 ┣ 📂 linux
 ┣ 📂 macos
 ┣ 📂 web
 ┗ 📂 windows
```

---

## 🛠️ Tech Stack

### Core Technologies
- **Flutter**: Cross-platform framework for a rich UI experience.
- **Dart**: The programming language behind Flutter.
- **Firebase**:
  - **Firebase Authentication**: Secure user login and registration.
  - **Cloud Firestore**: Efficient storage and retrieval of materials and user data.
  - **Firebase Analytics**: Tracks user interactions for insights.

### Dependencies
| Package                  | Version  | Purpose                     |
|--------------------------|----------|-----------------------------|
| `cloud_firestore`        | ^4.13.6  | Firestore database integration |
| `firebase_core`          | ^2.24.2  | Firebase core functionality |
| `firebase_auth`          | ^4.16.0  | User authentication         |
| `firebase_analytics`     | ^10.8.0  | Analytics tracking          |
| `loading_animation_widget` | ^1.0.0 | Loading animations          |
| `timeago`                | ^3.1.0   | Human-readable timestamps   |
| `card_swiper`            | ^3.0.1   | Image carousel functionality |
| `flutter_lints`          | ^2.0.0   | Code linting                |
| `flutter_launcher_icons` | ^0.9.2   | Custom app icons            |

---

## 🚀 Installation

1. **Clone the Repository**  
   ```bash
   git clone <repository-url>
   ```

2. **Install Dependencies**  
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**  
   - Set up your Firebase project.
   - Add `firebase.json` and update `firebase_options.dart` with your Firebase configuration.

4. **Run the App**  
   ```bash
   flutter run
   ```

---

## 👥 Team

Developed by a passionate team of five students as part of a college final assignment:  
- Rendy Pratama  
- Usman  
- Indra Wijaya  
- Marsella  
- Chelsea Samsi Wijaya  

---

## 📜 License

[Insert license information if applicable]

---

<div align="center">
  <strong>Made with ❤️ for music lovers!</strong>
</div>
