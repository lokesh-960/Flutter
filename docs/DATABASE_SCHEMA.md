# DATABASE SCHEMA & DATA DICTIONARY
# Digital Learning Management System (DLMS)

## 1. Cloud Firestore NoSQL Architecture
The DLMS database is designed on Google Cloud Firestore, utilizing a normalized document model with structured subcollections and optimized compound query indexes.

---

## 2. Collections Specification

### 2.1 Collection: `users`
Represents student learners, course instructors, and platform administrators.

| Field Name | Type | Required | Description | Access Policy |
| :--- | :--- | :--- | :--- | :--- |
| `uid` | String | Yes | Unique ID matching Firebase Auth UID | Public Read |
| `email` | String | Yes | Academic email address | Public Read |
| `displayName` | String | Yes | Learner or Instructor full name | Public Read |
| `role` | String | Yes | Permission tier: `'student' \| 'instructor' \| 'admin'` | Owner/Admin Write |
| `photoUrl` | String? | No | Storage URL to profile avatar | Owner/Admin Write |
| `bio` | String? | No | Academic interest or teacher bio | Owner/Admin Write |
| `createdAt` | Timestamp | Yes | Account creation timestamp | Owner Write |
| `enrolledCourseIds` | Array<String> | No | Fast reference list of active courses | Owner Write |
| `isDemoUser` | Boolean | Yes | Flag marking evaluative sample accounts | Public Read |

---

### 2.2 Collection: `courses`
Represents academic curricula available for discovery and self-paced enrollment.

| Field Name | Type | Required | Description | Access Policy |
| :--- | :--- | :--- | :--- | :--- |
| `id` | String | Yes | Course unique identifier | Public Read |
| `title` | String | Yes | Academic curriculum title | Public Read |
| `description` | String | Yes | Comprehensive course syllabus & description | Public Read |
| `instructorId` | String | Yes | UID of authoring educator | Public Read |
| `instructorName` | String | Yes | Display name of the instructor | Public Read |
| `category` | String | Yes | Subject (e.g. `'Programming Fundamentals'`) | Public Read |
| `difficulty` | String | Yes | Level (`'Beginner' \| 'Intermediate' \| 'Advanced'`) | Public Read |
| `durationMinutes` | Number | Yes | Total estimated completion time | Public Read |
| `lessonCount` | Number | Yes | Number of lessons in course | Public Read |
| `enrollmentCount` | Number | Yes | Total enrolled students count | Public Read |
| `thumbnailUrl` | String | Yes | Course display thumbnail | Public Read |
| `isPublished` | Boolean | Yes | Publishing visibility toggle | Instructor/Admin Write |
| `createdAt` | Timestamp | Yes | Date published | Instructor/Admin Write |
| `objectives` | Array<String> | Yes | Key learning outcomes | Public Read |
| `prerequisites` | Array<String> | Yes | Prior knowledge requirements | Public Read |
| `quizId` | String? | No | Reference to associated assessment | Public Read |

#### Subcollection: `courses/{courseId}/modules`
- `id` (String): Module ID
- `courseId` (String): Parent course reference
- `title` (String): Module unit title
- `orderIndex` (Number): Numerical sequence position

#### Subcollection: `courses/{courseId}/modules/{moduleId}/lessons`
- `id` (String): Lesson ID
- `title` (String): Lesson title
- `orderIndex` (Number): Lesson order within module
- `content` (String): Markdown formatted text and code blocks
- `estimatedMinutes` (Number): Reading time in minutes
- `isFreePreview` (Boolean): Allows access without enrollment

---

### 2.3 Collection: `enrollments`
Tracks a student's active engagement, progress, and lesson completion history.

| Field Name | Type | Required | Description | Access Policy |
| :--- | :--- | :--- | :--- | :--- |
| `id` | String | Yes | Enrollment document identifier | Owner/Admin |
| `userId` | String | Yes | UID of student learner | Owner/Admin |
| `courseId` | String | Yes | ID of enrolled course | Owner/Admin |
| `enrolledAt` | Timestamp | Yes | Timestamp of enrollment | Owner/Admin |
| `completedLessonIds`| Array<String> | Yes | Array of completed lesson IDs | Owner/Admin |
| `isCompleted` | Boolean | Yes | True when all lessons finished | Owner/Admin |
| `completedAt` | Timestamp? | No | Date when 100% completed | Owner/Admin |
| `lastAccessedLessonId`| String? | No | Resume pointer for self-paced reading | Owner/Admin |
| `lastAccessedAt` | Timestamp | Yes | Activity heartbeat timestamp | Owner/Admin |

---

### 2.4 Collection: `quizzes` & `quizAttempts`
Authoritative examination schema protecting answer keys from tampering.

#### Document: `quizzes/{quizId}`
- `id` (String): Unique assessment ID
- `courseId` (String): Associated course ID
- `title` (String): Assessment title
- `timeLimitMinutes` (Number): Countdown duration
- `passingScorePercentage` (Number): Threshold (e.g. 70%)
- `questions` (Array<Map>):
  - `id`: Question ID
  - `questionText`: Statement
  - `options`: List of 4 multiple-choice options
  - `correctOptionIndex`: Integer index of correct answer (Restricted)
  - `points`: Weight of question
  - `explanation`: Pedagogical explanation

#### Document: `quizAttempts/{attemptId}`
- `id` (String): Attempt record ID
- `quizId` (String): Quiz reference
- `courseId` (String): Course reference
- `userId` (String): Student UID
- `score` (Number): Earned points
- `totalPoints` (Number): Maximum available points
- `percentage` (Number): Calculated percentage score
- `passed` (Boolean): Authoritative pass/fail flag
- `selectedAnswers` (Map<String, Int>): Map of student selections
- `submittedAt` (Timestamp): Timestamp of submission

---

## 3. Compound Indexes Specification (`firestore.indexes.json`)
The following composite indexes are configured to ensure high-performance query execution:

1. **Course Discovery by Category & Published Status**:
   - `courses`: `category ASC`, `isPublished ASC`, `createdAt DESC`
2. **Course Discovery by Popularity**:
   - `courses`: `isPublished ASC`, `enrollmentCount DESC`
3. **Student Enrolled Courses Ordered by Recency**:
   - `enrollments`: `userId ASC`, `enrolledAt DESC`
4. **Student Assessment History**:
   - `quizAttempts`: `userId ASC`, `submittedAt DESC`
