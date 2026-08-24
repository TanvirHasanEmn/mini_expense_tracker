# Mini Expense Tracker

A clean, responsive cross-platform Flutter application designed to track and manage personal expenses in real time. Built using Flutter clean architecture, Riverpod for state management, Cloud Firestore for database storage, and Firebase Authentication for user sessions.

---

##  Demonstration & Download

* **Download Demo APK**: [Click here to download APK](https://drive.google.com/file/d/15F0MaByKVkq8R3il-g_brc9PSooXWwbX/view?usp=sharing)
* **YouTube Walkthrough**: [Click here to watch video](https://youtu.be/tu_UOoUM8ag?si=IaCStlK70CHvyfOd)

---

## Getting Started

### Prerequisites
* Flutter SDK (3.x or later)
* Android Studio / VS Code
* Firebase CLI installed (`firebase-tools`)

### Installation & Setup

1. **Clone the repository:**
   git clone https://github.com/your-username/mini-expense-tracker.git
   
   cd mini-expense-tracker

3. **Install dependencies:**
   
flutter pub get

5. **Configure Firebase:**
   
Create a project in the Firebase Console.

Enable Email/Password under Authentication.

Enable Cloud Firestore in Test Mode.

6. **Run the FlutterFire CLI:**
flutterfire configure

4. **Run the App:**

flutter run


## Features
1. user signup and sign-in using Email & Password Authentication.

2. Session Persistence- Automatic routing upon cold restart using Firebase Auth native token caching and GoRouter redirect guards.

3. Logout- Custom bottom-sheet confirmation with session and state clearing.

4. Dynamic Calculations of Total Lifetime Expense and Current Month's Expense.

5.  Automatically lists the 5 most recent transactions with instant UI update.

6. Add Expense- Record amounts, categories, custom dates, and optional notes with form validations and loading indicators.

7. Edit Expense- Pre-filled update screen to modify existing transactions.

8. Delete with Confirmation: Dialog safeguard to prevent accidental deletion, refreshing local metrics upon confirmation.

9. User Profile- Displays authenticated user account details (name, email, registration date).

10. Dedicated logout action with confirmation bottom sheet.

## Tech Stack & Architecture
Framework: Flutter (Dart with strict null-safety)

State Management: Flutter Riverpod (StateNotifierProvider, StreamProvider)

Backend & Database: Firebase Authentication, Cloud Firestore

Navigation: GoRouter (Declarative routing with auth state redirect guards)

Responsive Design: flutter_screenutil

Typography & Icons: google_fonts (Inter), Material Symbols
