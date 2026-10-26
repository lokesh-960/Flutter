# SYSTEM ARCHITECTURE SPECIFICATION
# Digital Learning Management System (DLMS)

## 1. Architectural Philosophy & Overview
The **Digital Learning Management System (DLMS)** employs a clean, layered feature-first architecture that strictly decouples presentation interfaces, business logic/state controllers, data abstraction boundaries, and cloud/local persistence services.

```
┌──────────────────────────────────────────────────────────────────┐
│                      Presentation Layer                          │
│  - Screens & Viewports (Mobile, Tablet, Desktop)                 │
│  - Reusable Material 3 Design Components                         │
│  - Declarative Route Mapping (GoRouter)                          │
└─────────────────────────────────┬────────────────────────────────┘
                                  │
┌─────────────────────────────────▼────────────────────────────────┐
│                   State Management & Domain                      │
│  - AuthProvider (Session, Identity, Roles)                       │
│  - CourseProvider (Catalog, Search, Filtering, Bookmarks)        │
│  - LearningProvider (Enrollments, Progress, Lesson Completions)  │
│  - QuizProvider (Authoritative Grading, Assessments, History)    │
│  - InstructorProvider (Curriculum Creation & Cohort Analytics)   │
│  - AdminProvider (User Governance, Moderation, Announcements)    │
└─────────────────────────────────┬────────────────────────────────┘
                                  │
┌─────────────────────────────────▼────────────────────────────────┐
│                   Data & Persistence Layer                       │
│  - LocalStorageService (SharedPreferences Cache & Reading State) │
│  - Cloud Firestore Repositories (NoSQL Data Models)              │
│  - Firebase Authentication Service (Token Verification)          │
│  - Firebase Storage Service (Media Assets & Resources)           │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2. Structural Layer Descriptions

### Layer 1: Presentation & UI
- **Responsive Layout Engine (`ResponsiveLayout`)**: Dynamically swaps between Mobile (<650px), Tablet (650-1050px), and Desktop/Web (>1050px) configurations without rebuild jank or overflow errors.
- **Material 3 Design Tokens**: Governed by `AppTheme`, utilizing academic typography (Google Fonts Inter), crisp contrast ratios, and tailored color accents.
- **Declarative Navigation (`app_router.dart`)**: Uses `go_router` with URL routing, parameter parsing (`/lesson/:courseId/:lessonId`), and role guard intercepts.

### Layer 2: State Management & Application Logic
- **Decoupled Providers**: Built on Flutter's `provider` package using `ChangeNotifier` and `ProxyProvider` dependencies.
- **Authoritative Grading Engine**: Enforces that quiz percentages and pass/fail statuses are computed programmatically against question points rather than accepting client-submitted totals.
- **Progress Tracking**: Course completion percentage is calculated strictly using `completedLessons.length / totalLessons` to guarantee academic integrity.

### Layer 3: Persistence & Dual-Service Architecture
- **Offline / Low-Bandwidth Resilience**: Course curricula, accessed lesson reading state, and enrollment records are cached in `SharedPreferences` to ensure continuous functionality in low-connectivity areas.
- **Firebase Integration Layer**: Direct integration with Firebase Authentication, Cloud Firestore, and Firebase Storage governed by `firestore.rules`.

---

## 3. High-Level Architectural Diagrams

### 3.1 Layered Data Flow Architecture
```mermaid
graph TD
    Client[Client Device - Web / Android]
    Router[GoRouter - Guard & Dispatcher]
    
    subgraph Providers [State Management Layer]
        AP[AuthProvider]
        CP[CourseProvider]
        LP[LearningProvider]
        QP[QuizProvider]
        IP[InstructorProvider]
        AdmP[AdminProvider]
    end

    subgraph Storage [Data Access Layer]
        LocalCache[(SharedPreferences Cache)]
        Firestore[(Cloud Firestore)]
        StorageBucket[(Firebase Cloud Storage)]
    end

    Client --> Router
    Router --> Providers
    Providers --> LocalCache
    Providers --> Firestore
    Providers --> StorageBucket
```

### 3.2 Quiz Execution & Authoritative Grading Sequence
```mermaid
sequenceDiagram
    autonumber
    actor Learner as Student User
    participant View as QuizScreen
    participant Controller as QuizProvider
    participant DB as LocalStorage / Firestore

    Learner->>View: Selects Course Quiz
    View->>Controller: Fetches Quiz Questions (IDs, Options, Points)
    Note over View,Controller: Correct option keys excluded from public view
    Learner->>View: Answers Question 1..N
    Learner->>View: Clicks "Submit Assessment"
    View->>Controller: submitQuizAttempt(quiz, userId, selectedAnswers)
    Controller->>Controller: Compares user selections against answer key
    Controller->>Controller: Computes earned points & percentage
    Controller->>Controller: Checks percentage >= passingScorePercentage
    Controller->>DB: Saves QuizAttemptModel record
    Controller-->>View: Returns verified QuizAttemptModel
    View->>Learner: Renders QuizResultScreen with pass/fail badge & review
```

---

## 4. Architectural Quality Attributes
- **Maintainability**: Feature-driven directory layout ensures that additions to courses, quizzes, or admin modules do not touch unrelated logic.
- **Testability**: Independent models and providers allow unit testing without requiring real network sockets.
- **Security**: Separation of privilege between Students, Instructors, and Administrators enforced through route guards and Firestore rules.
