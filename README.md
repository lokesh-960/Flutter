# Digital Learning Management System (DLMS)

[![Flutter Stable](https://img.shields.io/badge/Flutter-3.47.8-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.7-0175C2?logo=dart)](https://dart.dev)
[![UN SDG 4](https://img.shields.io/badge/UN%20SDG-4%20Quality%20Education-C5192D)](https://sdgs.un.org/goals/goal4)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **College Flutter SDG Capstone Project | Evaluated for 25 Marks**  
> A modern, responsive, accessible, full-featured educational platform built using Flutter and Dart, aligned directly with **United Nations Sustainable Development Goal 4 (Quality Education)**.

---

## 📌 Table of Contents
- [Executive Overview](#executive-overview)
- [UN SDG 4 Alignment](#un-sdg-4-alignment)
- [System Architecture & Tech Stack](#system-architecture--tech-stack)
- [Role-Based Access Control (RBAC)](#role-based-access-control-rbac)
- [Curriculum Catalog (Seed Dataset)](#curriculum-catalog-seed-dataset)
- [Demonstration Accounts](#demonstration-accounts)
- [Local Installation & Run Guide](#local-installation--run-guide)
- [Testing & Quality Assurance](#testing--quality-assurance)
- [Web & Android Deployment](#web--android-deployment)
- [Firebase Cloud Configuration](#firebase-cloud-configuration)
- [Project Documentation Suite](#project-documentation-suite)

---

## 🎯 Executive Overview
The **Digital Learning Management System (DLMS)** addresses critical educational disparities caused by financial constraints, geographic isolation, and intermittent internet connectivity. 

### Key Capabilities:
- **Universal Multi-Platform Support**: Responsive Material 3 user interface optimized across Android smartphones, tablets, and modern desktop/web browsers.
- **Self-Paced Learning Engine**: Complete curriculum hierarchy with modules, formatted code blocks, lesson reading timers, sequential navigation, and persistent lesson completion tracking.
- **Authoritative Quiz Assessment**: Interactive multiple-choice examination engine featuring real-time countdown timers, authoritative scoring, pass/fail thresholds, and detailed answer review with pedagogical explanations.
- **Academic Progress & Milestone Badges**: Transparent, real-data-driven metric dashboards and achievement badges (e.g., First Step, Knowledge Seeker, Certified Scholar).
- **Instructor Academic Studio**: Course creation, curriculum module authoring, lesson builder, and student cohort enrollment tracking.
- **Institutional Admin Console**: Comprehensive system KPI monitoring, role management (Student, Instructor, Administrator), course catalog moderation, and campus announcements.
- **Low-Bandwidth & Offline Resilience**: Local caching via `shared_preferences` and persistent storage so accessed lessons and curriculum metadata remain readable without active internet connection.

---

## 🌍 UN SDG 4 Alignment
The platform is engineered around the core targets of **United Nations Sustainable Development Goal 4: Quality Education**:
1. **Target 4.3 & 4.4 (Affordable & Equal Access to Technical & Tertiary Skills)**: Zero tuition fees or paywalls on foundational STEM courses.
2. **Target 4.5 (Eliminating Gender & Geographic Disparities)**: Low-bandwidth optimizations and device accessibility ensuring learners with basic smartphones can participate.
3. **Target 4.a (Inclusive & Safe Learning Environments)**: WCAG contrast compliance, screen-reader semantic trees, and dedicated digital safety curricula.

---

## 🏗️ System Architecture & Tech Stack
```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Presentation                     │
│  Material 3 | ResponsiveLayout | GoRouter | GoogleFonts    │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                   State Management Layer                    │
│   AuthProvider | CourseProvider | LearningProvider         │
│   QuizProvider | InstructorProvider | AdminProvider         │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                  Dual-Service Data Layer                    │
│  ┌───────────────────────────┐ ┌──────────────────────────┐ │
│  │ Cloud Firestore / Auth    │ │ LocalStorageService      │ │
│  │ Firebase Storage / Rules  │ │ Offline Cache & SeedData │ │
│  └───────────────────────────┘ └──────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

- **Frontend**: Flutter Stable Channel (v3.47.8), Dart SDK (v3.13.7)
- **UI System**: Material 3, Adaptive Breakpoints (Mobile < 650px, Tablet 650-1050px, Desktop > 1050px)
- **State Management**: `provider` (MultiProvider & ChangeNotifier architecture)
- **Navigation**: `go_router` (declarative role-based routing and guard redirects)
- **Persistence**: Dual architecture — `shared_preferences` local persistence + Firebase Authentication & Cloud Firestore schemas
- **Styling**: Tailored academic palette (Deep Indigo `#2563EB`, Restrained Teal `#0D9488`, UN SDG Crimson `#C5192D`)

---

## 👥 Role-Based Access Control (RBAC)

| User Role | Permitted Workspaces & Features |
| :--- | :--- |
| **Student** | Browse course discovery catalog, filter/search by category & difficulty, enroll in courses, view lessons, mark lessons as completed, take timed quizzes, view attempt history & answer keys, earn milestone achievement badges, update academic profile. |
| **Instructor** | Access Instructor Studio, create and edit courses, author modules and lessons, configure quizzes and passing marks, toggle course publication, monitor cohort enrollments. |
| **Administrator** | Access Admin Governance Console, inspect global platform KPIs, manage user roles (Student, Instructor, Admin), moderate published courses, broadcast campus announcements, monitor learner issue reports. |

---

## 📚 Curriculum Catalog (Seed Dataset)
DLMS ships with **six complete, fully populated academic courses** with authentic lessons and certification quizzes:

1. **Programming Fundamentals: Python for Everyone** (4 Lessons, Quiz)
2. **Object-Oriented Programming with Java** (4 Lessons, Quiz)
3. **Full-Stack Modern Web Development** (4 Lessons, Quiz)
4. **Relational Database Management & SQL** (4 Lessons, Quiz)
5. **Digital Literacy & Online Safety** (4 Lessons, Quiz)
6. **Discrete Mathematics & Computational Logic** (4 Lessons, Quiz)

---

## 🔑 Demonstration Accounts
Pre-configured demo credentials available on the Login screen via one-tap evaluator buttons:

| Role | Email Address | Password |
| :--- | :--- | :--- |
| **Student** | `student@dlms.edu` | `Password123!` |
| **Instructor** | `instructor@dlms.edu` | `Password123!` |
| **Administrator** | `admin@dlms.edu` | `Password123!` |

*(Evaluators can also switch roles dynamically anytime via the Profile screen).*

---

## 🚀 Local Installation & Run Guide

### Prerequisites
- Flutter SDK (v3.10.0 or higher)
- Dart SDK (v3.0.0 or higher)
- Google Chrome browser (for web run) or Android emulator / physical device

### Step-by-Step Commands:
```bash
# 1. Clone repository
git clone https://github.com/your-username/digital-learning-management-system.git
cd digital-learning-management-system

# 2. Install project dependencies
flutter pub get

# 3. Verify static code analysis
flutter analyze

# 4. Execute all automated tests
flutter test

# 5. Launch web application in Chrome
flutter run -d chrome

# 6. (Alternative) Build production web bundle
flutter build web --release
```

---

## 🧪 Testing & Quality Assurance
The codebase includes comprehensive unit and widget tests:
- `test/unit/course_model_test.dart`: Serialization and module duration calculations.
- `test/unit/quiz_scoring_test.dart`: Authoritative grading, points calculation, and passing thresholds.
- `test/unit/enrollment_progress_test.dart`: Progress math, edge cases, and completion triggers.
- `test/widget/custom_button_test.dart`: Button states, callback triggers, and loading spinners.
- `test/widget_test.dart`: Root application widget smoke test.

Execute tests with:
```bash
flutter test
```

---

## 🌐 Web & Android Deployment

### A. Flutter Web Release & Firebase Hosting
1. Build production web bundle:
   ```bash
   flutter build web --release
   ```
2. Initialize and deploy to Firebase Hosting:
   ```bash
   firebase login
   firebase init hosting
   firebase deploy --only hosting
   ```

### B. Android APK Build
1. Connect physical Android device or start Android Emulator.
2. Build unsigned release APK:
   ```bash
   flutter build apk --release
   ```
   *Generated output:* `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔒 Firebase Cloud Configuration
All security and indexing rules are prepared and validated:
- `firestore.rules`: Prevents privilege escalation and unauthorized course edits.
- `storage.rules`: Validates mime-types and enforces 5MB avatar / 25MB document limits.
- `firestore.indexes.json`: Optimized compound indexes for catalog sorting and progress queries.

---

## 📖 Project Documentation Suite
All academic project documentation is located in the `docs/` folder:
- [`docs/PROJECT_REPORT.md`](docs/PROJECT_REPORT.md): Complete academic report (25 marks rubric).
- [`docs/SYSTEM_ARCHITECTURE.md`](docs/SYSTEM_ARCHITECTURE.md): Architectural designs and Mermaid diagrams.
- [`docs/DATABASE_SCHEMA.md`](docs/DATABASE_SCHEMA.md): Firestore NoSQL entity relationships and index definitions.
- [`docs/TESTING_REPORT.md`](docs/TESTING_REPORT.md): Test methodology, cases, and execution log.
- [`docs/DEPLOYMENT_GUIDE.md`](docs/DEPLOYMENT_GUIDE.md): Firebase Hosting and Android APK deployment manual.
- [`docs/USER_MANUAL.md`](docs/USER_MANUAL.md): Step-by-step role-based user guide with workflows.
- [`docs/SDG_IMPACT.md`](docs/SDG_IMPACT.md): Detailed alignment with UN SDG 4 Targets.
- [`docs/VIVA_QUESTIONS.md`](docs/VIVA_QUESTIONS.md): Comprehensive viva defense questions with answers.
- [`docs/VEDIC_SUBMISSION_CHECKLIST.md`](docs/VEDIC_SUBMISSION_CHECKLIST.md): Institutional submission checklist.
