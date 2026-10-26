import '../features/auth/models/user_model.dart';
import '../features/courses/models/course_model.dart';
import '../features/courses/models/module_model.dart';
import '../features/courses/models/lesson_model.dart';
import '../features/quizzes/models/quiz_model.dart';
import '../features/announcements/models/announcement_model.dart';

class SeedData {
  // Demo Users
  static final List<UserModel> sampleUsers = [
    UserModel(
      uid: 'student-demo-01',
      email: 'student@dlms.edu',
      displayName: 'Alex Morgan',
      role: 'student',
      photoUrl: null,
      bio: 'Enthusiastic Computer Science student passionate about accessible education.',
      createdAt: DateTime(2026, 1, 15),
      enrolledCourseIds: ['course-python-101', 'course-web-101'],
      isDemoUser: true,
    ),
    UserModel(
      uid: 'instructor-demo-01',
      email: 'instructor@dlms.edu',
      displayName: 'Dr. Maya Patel',
      role: 'instructor',
      photoUrl: null,
      bio: 'Associate Professor of Computer Engineering with 12+ years teaching experience.',
      createdAt: DateTime(2025, 8, 10),
      enrolledCourseIds: [],
      isDemoUser: true,
    ),
    UserModel(
      uid: 'admin-demo-01',
      email: 'admin@dlms.edu',
      displayName: 'System Administrator',
      role: 'admin',
      photoUrl: null,
      bio: 'Institutional Administrator responsible for platform governance and SDG reporting.',
      createdAt: DateTime(2025, 1, 1),
      enrolledCourseIds: [],
      isDemoUser: true,
    ),
  ];

  // Quizzes for Courses
  static final List<QuizModel> sampleQuizzes = [
    const QuizModel(
      id: 'quiz-python-101',
      courseId: 'course-python-101',
      title: 'Python Fundamentals Assessment',
      description: 'Test your understanding of Python variables, control structures, and basic functions.',
      timeLimitMinutes: 15,
      passingScorePercentage: 70,
      questions: [
        QuizQuestionModel(
          id: 'q-py-1',
          questionText: 'What is the correct file extension for Python files?',
          options: ['.pt', '.py', '.pyt', '.python'],
          correctOptionIndex: 1,
          explanation: 'Standard Python source code files use the .py file extension.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-py-2',
          questionText: 'Which function is used to output text to the console in Python?',
          options: ['echo()', 'console.log()', 'print()', 'System.out.println()'],
          correctOptionIndex: 2,
          explanation: 'The built-in print() function writes formatted text to standard output.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-py-3',
          questionText: 'What is the output of len([10, 20, 30, 40])?',
          options: ['3', '4', '5', '40'],
          correctOptionIndex: 1,
          explanation: 'len() returns the total number of items in a sequence (here, 4 elements).',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-py-4',
          questionText: 'Which of the following creates a immutable collection in Python?',
          options: ['list', 'dict', 'tuple', 'set'],
          correctOptionIndex: 2,
          explanation: 'Tuples are ordered and immutable sequences defined using parentheses.',
          points: 1,
        ),
      ],
    ),
    const QuizModel(
      id: 'quiz-java-101',
      courseId: 'course-java-101',
      title: 'Java Object-Oriented Principles Quiz',
      description: 'Evaluate your knowledge of classes, inheritance, encapsulation, and polymorphism.',
      timeLimitMinutes: 20,
      passingScorePercentage: 75,
      questions: [
        QuizQuestionModel(
          id: 'q-java-1',
          questionText: 'Which keyword is used to inherit a class in Java?',
          options: ['implements', 'inherits', 'extends', 'super'],
          correctOptionIndex: 2,
          explanation: 'The extends keyword is used to derive a subclass from a superclass in Java.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-java-2',
          questionText: 'What is the default value of an uninitialized boolean variable in a Java class?',
          options: ['true', 'false', 'null', '0'],
          correctOptionIndex: 1,
          explanation: 'Instance fields of type boolean default to false in Java.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-java-3',
          questionText: 'Which principle restricts direct access to an object\'s internal fields?',
          options: ['Polymorphism', 'Encapsulation', 'Abstraction', 'Inheritance'],
          correctOptionIndex: 1,
          explanation: 'Encapsulation bundles data with methods and restricts direct attribute access via private modifiers.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-java-4',
          questionText: 'Which method serves as the entry point for standalone Java applications?',
          options: ['start()', 'main()', 'init()', 'run()'],
          correctOptionIndex: 1,
          explanation: 'public static void main(String[] args) is the required JVM entry point.',
          points: 1,
        ),
      ],
    ),
    const QuizModel(
      id: 'quiz-web-101',
      courseId: 'course-web-101',
      title: 'Modern Web Development Fundamentals',
      description: 'Evaluate your knowledge of HTML5, CSS Flexbox/Grid, and JavaScript ES6+.',
      timeLimitMinutes: 15,
      passingScorePercentage: 70,
      questions: [
        QuizQuestionModel(
          id: 'q-web-1',
          questionText: 'Which HTML5 semantic element is best suited for independent, syndicatable content?',
          options: ['<section>', '<div>', '<article>', '<aside>'],
          correctOptionIndex: 2,
          explanation: 'The <article> tag represents a self-contained composition intended to be independently reusable.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-web-2',
          questionText: 'Which CSS property defines the primary axis alignment in Flexbox?',
          options: ['align-items', 'justify-content', 'flex-direction', 'align-content'],
          correctOptionIndex: 1,
          explanation: 'justify-content distributes space along the main axis of the current flex line.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-web-3',
          questionText: 'What does the JavaScript Promise state "resolved" indicate?',
          options: ['Pending execution', 'Operation succeeded', 'Operation encountered error', 'Promise timed out'],
          correctOptionIndex: 1,
          explanation: 'A fulfilled/resolved promise indicates the asynchronous operation finished successfully.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-web-4',
          questionText: 'Which HTTP status code signifies a successful resource creation?',
          options: ['200 OK', '201 Created', '204 No Content', '301 Moved Permanently'],
          correctOptionIndex: 1,
          explanation: 'HTTP 201 Created confirms that the request succeeded and a new resource was created.',
          points: 1,
        ),
      ],
    ),
    const QuizModel(
      id: 'quiz-db-101',
      courseId: 'course-db-101',
      title: 'Database Management & SQL Certification',
      description: 'Test relational database queries, join mechanics, and transactional properties.',
      timeLimitMinutes: 20,
      passingScorePercentage: 70,
      questions: [
        QuizQuestionModel(
          id: 'q-db-1',
          questionText: 'Which SQL clause is used to filter records after aggregate groupings have been computed?',
          options: ['WHERE', 'ORDER BY', 'HAVING', 'GROUP BY'],
          correctOptionIndex: 2,
          explanation: 'The HAVING clause filters groups created by GROUP BY based on aggregate conditions.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-db-2',
          questionText: 'What does ACID stand for in database transaction management?',
          options: [
            'Atomicity, Consistency, Isolation, Durability',
            'Accuracy, Concurrency, Integrity, Durability',
            'Atomicity, Coherence, Isolation, Dependency',
            'Action, State, Integrity, Durability'
          ],
          correctOptionIndex: 0,
          explanation: 'ACID guarantees reliable processing of database transactions.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-db-3',
          questionText: 'Which type of JOIN returns only rows with matching values in both tables?',
          options: ['LEFT JOIN', 'FULL OUTER JOIN', 'INNER JOIN', 'CROSS JOIN'],
          correctOptionIndex: 2,
          explanation: 'INNER JOIN selects records that have matching values in both referenced tables.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-db-4',
          questionText: 'Which normal form eliminates partial dependencies on a composite primary key?',
          options: ['First Normal Form (1NF)', 'Second Normal Form (2NF)', 'Third Normal Form (3NF)', 'BCNF'],
          correctOptionIndex: 1,
          explanation: '2NF requires 1NF compliance and that all non-key attributes are fully dependent on the primary key.',
          points: 1,
        ),
      ],
    ),
    const QuizModel(
      id: 'quiz-digital-101',
      courseId: 'course-digital-101',
      title: 'Digital Literacy & Cybersecurity Hygiene',
      description: 'Evaluate essential knowledge of digital privacy, password strength, and phishing detection.',
      timeLimitMinutes: 15,
      passingScorePercentage: 80,
      questions: [
        QuizQuestionModel(
          id: 'q-dig-1',
          questionText: 'What is Multi-Factor Authentication (MFA)?',
          options: [
            'Using the same password across multiple sites',
            'Requiring two or more verification factors to gain account access',
            'Encrypting a hard drive twice',
            'Changing passwords every 24 hours'
          ],
          correctOptionIndex: 1,
          explanation: 'MFA adds critical security layers by requiring something you know, something you have, or something you are.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-dig-2',
          questionText: 'Which indicator suggests an email may be a phishing attempt?',
          options: [
            'Personalized greeting from known colleague',
            'Urgent threats of account suspension with mismatched sender domain links',
            'Verified digital signature',
            'Clear unsubscribe link from a recognized service'
          ],
          correctOptionIndex: 1,
          explanation: 'Artificial urgency and mismatched sender domains are hallmark indicators of phishing attacks.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-dig-3',
          questionText: 'What is the purpose of Creative Commons licenses in open education?',
          options: [
            'Prohibiting all digital copying',
            'Standardizing copyright permissions so creators can share works freely under clear terms',
            'Charging licensing fees for educational texts',
            'Enforcing software patents globally'
          ],
          correctOptionIndex: 1,
          explanation: 'Creative Commons enables authors to grant public copyright permissions to encourage knowledge sharing (SDG 4).',
          points: 1,
        ),
      ],
    ),
    const QuizModel(
      id: 'quiz-math-101',
      courseId: 'course-math-101',
      title: 'Discrete Mathematics & Computational Logic',
      description: 'Assessment covering propositional logic, set theory, and algorithmic complexity.',
      timeLimitMinutes: 20,
      passingScorePercentage: 70,
      questions: [
        QuizQuestionModel(
          id: 'q-math-1',
          questionText: 'If statement P is True and statement Q is False, what is the truth value of (P AND Q)?',
          options: ['True', 'False', 'Undefined', 'Contingent'],
          correctOptionIndex: 1,
          explanation: 'A logical conjunction (AND) evaluates to True only when all operands are True.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-math-2',
          questionText: 'What is the time complexity of Binary Search on a sorted array of size N?',
          options: ['O(1)', 'O(log N)', 'O(N)', 'O(N^2)'],
          correctOptionIndex: 1,
          explanation: 'Binary Search halves the search space at each comparison step, achieving logarithmic O(log N) time.',
          points: 1,
        ),
        QuizQuestionModel(
          id: 'q-math-3',
          questionText: 'What is the cardinality of the power set of a set with 4 distinct elements?',
          options: ['8', '12', '16', '32'],
          correctOptionIndex: 2,
          explanation: 'The power set of a set with n elements has 2^n elements. Here, 2^4 = 16.',
          points: 1,
        ),
      ],
    ),
  ];

  // Complete Sample Courses
  static final List<CourseModel> sampleCourses = [
    CourseModel(
      id: 'course-python-101',
      title: 'Programming Fundamentals: Python for Everyone',
      description: 'Master the foundational concepts of computer programming using Python. Designed specifically for beginners seeking clear, hands-on, self-paced computational thinking.',
      instructorId: 'instructor-demo-01',
      instructorName: 'Prof. Alan Vance',
      category: 'Programming Fundamentals',
      difficulty: 'Beginner',
      durationMinutes: 180,
      lessonCount: 4,
      enrollmentCount: 1420,
      thumbnailUrl: 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=800',
      isPublished: true,
      createdAt: DateTime(2025, 9, 1),
      quizId: 'quiz-python-101',
      isFeatured: true,
      objectives: [
        'Understand algorithms, variables, and primitive data types',
        'Implement structured decision-making using conditionals and loops',
        'Write modular, reusable functions and handle runtime exceptions',
        'Apply computational problem solving to real-world datasets',
      ],
      prerequisites: [
        'Basic familiarity with operating a computer or smartphone',
        'No prior programming experience required',
      ],
      modules: [
        const ModuleModel(
          id: 'mod-py-1',
          courseId: 'course-python-101',
          title: 'Module 1: Computational Thinking & Core Syntax',
          orderIndex: 0,
          description: 'Introduction to Python syntax, dynamic typing, arithmetic operations, and standard I/O.',
          lessons: [
            LessonModel(
              id: 'les-py-1',
              courseId: 'course-python-101',
              moduleId: 'mod-py-1',
              title: '1.1 Introduction to Python & Algorithm Basics',
              orderIndex: 0,
              estimatedMinutes: 20,
              isFreePreview: true,
              content: '''# Welcome to Python Programming

Python is an interpreted, high-level, general-purpose programming language. Created by Guido van Rossum and released in 1991, its design philosophy emphasizes code readability through clean indentation.

## Why Learn Python for SDG 4?
Under UN Sustainable Development Goal 4 (Quality Education), learning computational thinking bridges the digital divide and provides foundational skills for 21st-century problem solving.

## The First Program:
```python
# The classic greeting to the computing world
def main():
    greeting = "Hello, Digital Learning Management System!"
    print(greeting)

if __name__ == "__main__":
    main()
```

### Key Elements:
1. **Keywords**: Reserved tokens such as `def`, `if`, and `print`.
2. **Indentation**: Whitespace blocks define code structure instead of curly braces.
3. **Dynamic Typing**: Variables adapt to assigned values without explicit type declarations.
''',
            ),
            LessonModel(
              id: 'les-py-2',
              courseId: 'course-python-101',
              moduleId: 'mod-py-1',
              title: '1.2 Variables, Expressions & Data Types',
              orderIndex: 1,
              estimatedMinutes: 25,
              content: '''# Variables, Expressions & Data Types

In Python, variables are symbolic names referencing memory locations that hold values.

## Core Primitive Types:
- **int**: Whole numbers (e.g., `42`, `-7`)
- **float**: Real numbers with decimals (e.g., `3.14159`, `-0.001`)
- **str**: Textual strings enclosed in single or double quotes
- **bool**: Logical truth values (`True` or `False`)

## Example Code:
```python
student_name = "Alex"
enrolled_courses = 4
average_score = 92.5
is_active = True

print(f"Student: {student_name} | Active: {is_active}")
print(f"Current Average: {average_score}% across {enrolled_courses} courses.")
```

### Type Conversion:
You can cast types using built-in constructors: `int("100")`, `str(45)`, `float(12)`.
''',
            ),
          ],
        ),
        const ModuleModel(
          id: 'mod-py-2',
          courseId: 'course-python-101',
          title: 'Module 2: Control Flow & Modular Functions',
          orderIndex: 1,
          description: 'Master branching conditionals, iterative loops, and functional encapsulation.',
          lessons: [
            LessonModel(
              id: 'les-py-3',
              courseId: 'course-python-101',
              moduleId: 'mod-py-2',
              title: '2.1 Conditionals & Decision Making',
              orderIndex: 0,
              estimatedMinutes: 25,
              content: '''# Decision Making with If-Else

Programs make decisions using logical operators:
- Equal to: `==`
- Not equal to: `!=`
- Greater than / Less than: `>`, `<`
- Compound conditions: `and`, `or`, `not`

```python
score = 85

if score >= 90:
    grade = "A"
elif score >= 75:
    grade = "B"
elif score >= 60:
    grade = "C"
else:
    grade = "D"

print(f"Your calculated grade is: {grade}")
```
''',
            ),
            LessonModel(
              id: 'les-py-4',
              courseId: 'course-python-101',
              moduleId: 'mod-py-2',
              title: '2.2 Iteration with For & While Loops',
              orderIndex: 1,
              estimatedMinutes: 30,
              content: '''# Iteration with Loops

Loops allow a block of statements to be executed repeatedly.

## For Loop Example:
```python
learning_modules = ["Syntax", "Variables", "Conditionals", "Loops", "Functions"]

print("Course Syllabus:")
for index, module in enumerate(learning_modules, start=1):
    print(f"Module {index}: {module}")
```

## While Loop Example:
```python
countdown = 5
while countdown > 0:
    print(f"Lesson begins in {countdown}...")
    countdown -= 1
print("Let's code!")
```
''',
            ),
          ],
        ),
      ],
    ),

    CourseModel(
      id: 'course-java-101',
      title: 'Object-Oriented Programming with Java',
      description: 'Build enterprise-grade software architectures using Java. Master object-oriented principles including encapsulation, inheritance, polymorphism, and robust exception handling.',
      instructorId: 'instructor-demo-01',
      instructorName: 'Dr. Maya Patel',
      category: 'Java Programming',
      difficulty: 'Intermediate',
      durationMinutes: 240,
      lessonCount: 4,
      enrollmentCount: 980,
      thumbnailUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800',
      isPublished: true,
      createdAt: DateTime(2025, 9, 15),
      quizId: 'quiz-java-101',
      isFeatured: true,
      objectives: [
        'Understand JVM architecture, bytecode compilation, and memory management',
        'Design robust class hierarchies using encapsulation and inheritance',
        'Implement interface-driven polymorphism and abstract contracts',
        'Handle runtime anomalies reliably through structured exception handling',
      ],
      prerequisites: [
        'Basic understanding of programming logic and variables',
      ],
      modules: [
        const ModuleModel(
          id: 'mod-java-1',
          courseId: 'course-java-101',
          title: 'Module 1: Java Architecture & Class Design',
          orderIndex: 0,
          description: 'Understanding the JVM, class anatomy, constructors, and encapsulation.',
          lessons: [
            LessonModel(
              id: 'les-java-1',
              courseId: 'course-java-101',
              moduleId: 'mod-java-1',
              title: '1.1 The JVM Platform & Class Anatomy',
              orderIndex: 0,
              estimatedMinutes: 30,
              isFreePreview: true,
              content: '''# Java Architecture & Class Anatomy

Java is a compiled, object-oriented language that follows the principle: *"Write Once, Run Anywhere"* (WORA).

## Compilation Pipeline:
1. Source Code (`.java`) is compiled by `javac`.
2. Produces portable Bytecode (`.class`).
3. Java Virtual Machine (JVM) executes bytecode on the host OS.

## A Basic Class:
```java
public class Student {
    private String name;
    private int studentId;

    public Student(String name, int studentId) {
        this.name = name;
        this.studentId = studentId;
    }

    public String getName() {
        return name;
    }

    public void displayInfo() {
        System.out.println("ID: " + studentId + " | Name: " + name);
    }
}
```
''',
            ),
            LessonModel(
              id: 'les-java-2',
              courseId: 'course-java-101',
              moduleId: 'mod-java-1',
              title: '1.2 Encapsulation & Access Modifiers',
              orderIndex: 1,
              estimatedMinutes: 25,
              content: '''# Encapsulation & Information Hiding

Encapsulation protects object state from arbitrary external mutation.

## Access Modifiers:
- `public`: Accessible from any package.
- `protected`: Accessible within the same package and by subclasses.
- `default` (package-private): Accessible only within the declaring package.
- `private`: Strictly accessible only within the declaring class.

Always keep state attributes `private` and expose access via validated getters and setters.
''',
            ),
          ],
        ),
        const ModuleModel(
          id: 'mod-java-2',
          courseId: 'course-java-101',
          title: 'Module 2: Inheritance & Polymorphic Contracts',
          orderIndex: 1,
          description: 'Subclassing, method overriding, and interface abstractions.',
          lessons: [
            LessonModel(
              id: 'les-java-3',
              courseId: 'course-java-101',
              moduleId: 'mod-java-2',
              title: '2.1 Inheritance & the `super` Keyword',
              orderIndex: 0,
              estimatedMinutes: 30,
              content: '''# Inheritance in Java

Inheritance establishes an "IS-A" relationship between a generalized superclass and specialized subclasses.

```java
public class Person {
    protected String email;

    public Person(String email) {
        this.email = email;
    }
}

public class Instructor extends Person {
    private String department;

    public Instructor(String email, String department) {
        super(email); // invoke parent constructor
        this.department = department;
    }
}
```
''',
            ),
            LessonModel(
              id: 'les-java-4',
              courseId: 'course-java-101',
              moduleId: 'mod-java-2',
              title: '2.2 Polymorphism & Java Interfaces',
              orderIndex: 1,
              estimatedMinutes: 35,
              content: '''# Polymorphism & Interfaces

Polymorphism enables treating instances of different subclasses through a uniform interface.

```java
public interface Gradable {
    double calculateGrade();
}

public class Assignment implements Gradable {
    private double rawScore;

    public Assignment(double rawScore) {
        this.rawScore = rawScore;
    }

    @Override
    public double calculateGrade() {
        return rawScore * 1.1; // curve factor
    }
}
```
''',
            ),
          ],
        ),
      ],
    ),

    CourseModel(
      id: 'course-web-101',
      title: 'Full-Stack Modern Web Development',
      description: 'Master modern frontend and responsive design using semantic HTML5, CSS Flexbox/Grid, and asynchronous ES6+ JavaScript. Designed for high performance and low bandwidth accessibility.',
      instructorId: 'instructor-demo-01',
      instructorName: 'Sarah Jenkins',
      category: 'Web Development',
      difficulty: 'Beginner',
      durationMinutes: 200,
      lessonCount: 4,
      enrollmentCount: 1850,
      thumbnailUrl: 'https://images.unsplash.com/photo-1547658719-da2b51169166?w=800',
      isPublished: true,
      createdAt: DateTime(2025, 10, 1),
      quizId: 'quiz-web-101',
      isFeatured: true,
      objectives: [
        'Structure accessible, SEO-friendly layouts using HTML5 semantic elements',
        'Build responsive multi-device interfaces with CSS Grid and Flexbox',
        'Handle user interaction dynamically using ES6+ JavaScript',
        'Consume RESTful APIs asynchronously using fetch and async/await',
      ],
      prerequisites: [
        'Familiarity with basic computer operations and web browsing',
      ],
      modules: [
        const ModuleModel(
          id: 'mod-web-1',
          courseId: 'course-web-101',
          title: 'Module 1: Semantic HTML5 & Responsive Styling',
          orderIndex: 0,
          description: 'Document structure, accessibility semantics, and fluid layouts.',
          lessons: [
            LessonModel(
              id: 'les-web-1',
              courseId: 'course-web-101',
              moduleId: 'mod-web-1',
              title: '1.1 Accessible Semantic HTML5',
              orderIndex: 0,
              estimatedMinutes: 25,
              isFreePreview: true,
              content: '''# Semantic HTML5 & Accessibility

Semantic HTML tags give meaning to web structure rather than just visual appearance.

## Essential Semantic Elements:
- `<header>`: Introductory content or navigational links
- `<nav>`: Major navigation blocks
- `<main>`: Unique dominant content of the document
- `<article>`: Self-contained composition
- `<section>`: Generic standalone thematic grouping
- `<footer>`: Closing metadata, authorship, and copyright

```html
<article class="course-summary">
  <header>
    <h1>Introduction to Web Semantics</h1>
    <p>Published for SDG 4 Quality Education</p>
  </header>
  <p>Accessible structures allow screen readers to parse content accurately.</p>
</article>
```
''',
            ),
            LessonModel(
              id: 'les-web-2',
              courseId: 'course-web-101',
              moduleId: 'mod-web-1',
              title: '1.2 Modern CSS Flexbox & Grid Systems',
              orderIndex: 1,
              estimatedMinutes: 30,
              content: '''# Modern CSS Flexbox & Grid

CSS Flexbox handles one-dimensional layouts, while CSS Grid manages two-dimensional matrix systems.

## Flexbox Core Properties:
```css
.card-container {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 1.5rem;
}
```

## CSS Grid Example:
```css
.course-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}
```
''',
            ),
          ],
        ),
        const ModuleModel(
          id: 'mod-web-2',
          courseId: 'course-web-101',
          title: 'Module 2: Asynchronous JavaScript (ES6+)',
          orderIndex: 1,
          description: 'DOM interaction, event handling, promises, and async/await network calls.',
          lessons: [
            LessonModel(
              id: 'les-web-3',
              courseId: 'course-web-101',
              moduleId: 'mod-web-2',
              title: '2.1 DOM Manipulation & Events',
              orderIndex: 0,
              estimatedMinutes: 25,
              content: '''# The Document Object Model (DOM)

JavaScript interacts with the browser viewport through the DOM API.

```javascript
const enrollButton = document.getElementById("enroll-btn");

enrollButton.addEventListener("click", (event) => {
  event.preventDefault();
  alert("Successfully enrolled in course!");
});
```
''',
            ),
            LessonModel(
              id: 'les-web-4',
              courseId: 'course-web-101',
              moduleId: 'mod-web-2',
              title: '2.2 Asynchronous Fetch & Promises',
              orderIndex: 1,
              estimatedMinutes: 30,
              content: '''# Asynchronous Fetch with Async/Await

Modern web applications communicate with backend cloud services asynchronously without blocking the user interface.

```javascript
async function loadCourseCurriculum(courseId) {
  try {
    const response = await fetch(`/api/courses/\${courseId}/modules`);
    if (!response.ok) {
      throw new Error(`HTTP error: \${response.status}`);
    }
    const data = await response.json();
    return data;
  } catch (err) {
    console.error("Failed to load curriculum:", err);
    return null;
  }
}
```
''',
            ),
          ],
        ),
      ],
    ),

    CourseModel(
      id: 'course-db-101',
      title: 'Relational Database Management & SQL',
      description: 'Design robust relational schemas, construct high-performance SQL queries, and understand database normalization, transaction isolation, and indexing strategies.',
      instructorId: 'instructor-demo-01',
      instructorName: 'David Okonjo',
      category: 'Database Management',
      difficulty: 'Intermediate',
      durationMinutes: 210,
      lessonCount: 4,
      enrollmentCount: 1120,
      thumbnailUrl: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=800',
      isPublished: true,
      createdAt: DateTime(2025, 10, 20),
      quizId: 'quiz-db-101',
      isFeatured: false,
      objectives: [
        'Design Entity-Relationship Diagrams (ERD) with primary and foreign keys',
        'Write complex queries using INNER, LEFT, and FULL OUTER joins',
        'Apply 1NF, 2NF, and 3NF normalization to eliminate data redundancy',
        'Implement ACID-compliant database transactions',
      ],
      prerequisites: [
        'Basic logical thinking and data comprehension',
      ],
      modules: [
        const ModuleModel(
          id: 'mod-db-1',
          courseId: 'course-db-101',
          title: 'Module 1: Relational Schema Modeling & DDL',
          orderIndex: 0,
          description: 'Tables, constraints, primary/foreign keys, and data definition language.',
          lessons: [
            LessonModel(
              id: 'les-db-1',
              courseId: 'course-db-101',
              moduleId: 'mod-db-1',
              title: '1.1 Schema Design & Primary Keys',
              orderIndex: 0,
              estimatedMinutes: 25,
              isFreePreview: true,
              content: '''# Relational Database Design

Relational databases organize information into tabular collections of rows (records) and columns (attributes).

```sql
CREATE TABLE courses (
  course_id VARCHAR(50) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  instructor_id VARCHAR(50) NOT NULL,
  duration_minutes INT DEFAULT 60,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
''',
            ),
            LessonModel(
              id: 'les-db-2',
              courseId: 'course-db-101',
              moduleId: 'mod-db-1',
              title: '1.2 Foreign Keys & Referential Integrity',
              orderIndex: 1,
              estimatedMinutes: 25,
              content: '''# Foreign Keys & Integrity

Foreign keys enforce referential relationships across entities.

```sql
CREATE TABLE enrollments (
  enrollment_id VARCHAR(50) PRIMARY KEY,
  user_id VARCHAR(50) NOT NULL,
  course_id VARCHAR(50) REFERENCES courses(course_id) ON DELETE CASCADE,
  enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
''',
            ),
          ],
        ),
        const ModuleModel(
          id: 'mod-db-2',
          courseId: 'course-db-101',
          title: 'Module 2: Advanced SQL Queries & Joins',
          orderIndex: 1,
          description: 'Multi-table queries, aggregation functions, and subqueries.',
          lessons: [
            LessonModel(
              id: 'les-db-3',
              courseId: 'course-db-101',
              moduleId: 'mod-db-2',
              title: '2.1 Joins & Multi-Table Queries',
              orderIndex: 0,
              estimatedMinutes: 30,
              content: '''# Multi-Table Relational Joins

Retrieve combined data across normalized tables:

```sql
SELECT 
  u.display_name, 
  c.title AS course_title, 
  e.enrolled_at
FROM enrollments e
INNER JOIN users u ON e.user_id = u.uid
INNER JOIN courses c ON e.course_id = c.course_id
WHERE c.category = 'Programming Fundamentals';
```
''',
            ),
            LessonModel(
              id: 'les-db-4',
              courseId: 'course-db-101',
              moduleId: 'mod-db-2',
              title: '2.2 Aggregation & Grouping',
              orderIndex: 1,
              estimatedMinutes: 30,
              content: '''# SQL Aggregation & Grouping

Compute summaries using `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`:

```sql
SELECT 
  c.category,
  COUNT(c.course_id) AS total_courses,
  AVG(c.duration_minutes) AS avg_duration
FROM courses c
GROUP BY c.category
HAVING COUNT(c.course_id) > 1;
```
''',
            ),
          ],
        ),
      ],
    ),

    CourseModel(
      id: 'course-digital-101',
      title: 'Digital Literacy & Online Safety',
      description: 'Develop essential 21st-century digital competencies. Learn password security, phishing prevention, digital ethics, open educational resources, and safe online collaboration under SDG 4.',
      instructorId: 'instructor-demo-01',
      instructorName: 'Elena Rostova',
      category: 'Digital Literacy',
      difficulty: 'Beginner',
      durationMinutes: 150,
      lessonCount: 4,
      enrollmentCount: 2340,
      thumbnailUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800',
      isPublished: true,
      createdAt: DateTime(2025, 11, 1),
      quizId: 'quiz-digital-101',
      isFeatured: true,
      objectives: [
        'Navigate cloud platforms and digital learning environments safely',
        'Identify deceptive phishing emails, fraudulent links, and malware risks',
        'Implement strong password management and multi-factor authentication',
        'Understand open educational licenses and respectful digital citizenship',
      ],
      prerequisites: [
        'None. Suitable for all learners.',
      ],
      modules: [
        const ModuleModel(
          id: 'mod-dig-1',
          courseId: 'course-digital-101',
          title: 'Module 1: Cyber Hygiene & Password Security',
          orderIndex: 0,
          description: 'Protecting personal identities and preventing unauthorized access.',
          lessons: [
            LessonModel(
              id: 'les-dig-1',
              courseId: 'course-digital-101',
              moduleId: 'mod-dig-1',
              title: '1.1 Creating Resilient Passwords & Using MFA',
              orderIndex: 0,
              estimatedMinutes: 20,
              isFreePreview: true,
              content: '''# Password Resilience & MFA

In an interconnected digital learning world, credential compromise is the most frequent attack vector.

## Best Practices:
1. **Passphrase Strategy**: Use 4+ random words (e.g., `solar-orbit-pencil-river`) rather than simple dictionary words.
2. **Never Reuse Passwords**: A compromise on one site must not compromise your academic or personal accounts.
3. **Multi-Factor Authentication (MFA)**: Always enable TOTP authenticator apps or biometric confirmation.
''',
            ),
            LessonModel(
              id: 'les-dig-2',
              courseId: 'course-digital-101',
              moduleId: 'mod-dig-1',
              title: '1.2 Recognizing Phishing & Social Engineering',
              orderIndex: 1,
              estimatedMinutes: 20,
              content: '''# Phishing Detection

Phishing attempts to manipulate users into disclosing confidential information.

## Red Flags:
- Sense of severe urgency ("Act within 10 minutes or your account will be deleted!")
- Mismatched URLs (Hover to reveal the actual destination domain)
- Unsolicited email attachments (`.exe`, `.scr`, or password-protected zip archives)
''',
            ),
          ],
        ),
        const ModuleModel(
          id: 'mod-dig-2',
          courseId: 'course-digital-101',
          title: 'Module 2: Open Educational Resources & Ethics',
          orderIndex: 1,
          description: 'Creative commons, academic integrity, and digital accessibility.',
          lessons: [
            LessonModel(
              id: 'les-dig-3',
              courseId: 'course-digital-101',
              moduleId: 'mod-dig-2',
              title: '2.1 Creative Commons & Open Access',
              orderIndex: 0,
              estimatedMinutes: 20,
              content: '''# Open Educational Resources (OER)

SDG 4 promotes inclusive and equitable quality education. OER allows educational materials to be freely downloaded, edited, and shared without financial barriers.

## Common CC Licenses:
- **CC BY**: Attribution permitted for any use
- **CC BY-SA**: ShareAlike requires derived works to use identical licensing
- **CC BY-NC**: Non-commercial distribution only
''',
            ),
            LessonModel(
              id: 'les-dig-4',
              courseId: 'course-digital-101',
              moduleId: 'mod-dig-2',
              title: '2.2 Digital Footprint & Ethical Citizenship',
              orderIndex: 1,
              estimatedMinutes: 20,
              content: '''# Your Digital Footprint

Every interaction leaves a lasting trace on internet infrastructure. Maintain professional digital communication, respect privacy rights, and uphold academic integrity during digital exams.
''',
            ),
          ],
        ),
      ],
    ),

    CourseModel(
      id: 'course-math-101',
      title: 'Discrete Mathematics & Computational Logic',
      description: 'Master the mathematical foundations of computer algorithms. Explore propositional logic, set theory, combinatorics, proof methods, and asymptotic computational complexity.',
      instructorId: 'instructor-demo-01',
      instructorName: 'Dr. Rajesh Kumar',
      category: 'Mathematics or Science',
      difficulty: 'Advanced',
      durationMinutes: 220,
      lessonCount: 4,
      enrollmentCount: 650,
      thumbnailUrl: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800',
      isPublished: true,
      createdAt: DateTime(2025, 11, 15),
      quizId: 'quiz-math-101',
      isFeatured: false,
      objectives: [
        'Formulate and evaluate propositional and predicate logic expressions',
        'Apply set operations, relations, and function mappings',
        'Analyze asymptotic algorithm runtimes using Big-O notation',
        'Construct rigorous mathematical proofs by induction',
      ],
      prerequisites: [
        'High school algebra and familiarity with programming variables',
      ],
      modules: [
        const ModuleModel(
          id: 'mod-math-1',
          courseId: 'course-math-101',
          title: 'Module 1: Propositional Logic & Truth Tables',
          orderIndex: 0,
          description: 'Boolean operators, logical equivalence, and formal inference.',
          lessons: [
            LessonModel(
              id: 'les-math-1',
              courseId: 'course-math-101',
              moduleId: 'mod-math-1',
              title: '1.1 Propositions & Boolean Connectives',
              orderIndex: 0,
              estimatedMinutes: 25,
              isFreePreview: true,
              content: '''# Propositional Logic

A proposition is a declarative statement that is either True (T) or False (F), but not both.

## Connectives:
- Negation: `NOT p` (`~p`)
- Conjunction: `p AND q` (`p ∧ q`)
- Disjunction: `p OR q` (`p ∨ q`)
- Conditional: `p IMPLIES q` (`p → q`)
- Biconditional: `p IFF q` (`p ↔ q`)
''',
            ),
            LessonModel(
              id: 'les-math-2',
              courseId: 'course-math-101',
              moduleId: 'mod-math-1',
              title: '1.2 Truth Tables & Logical Equivalence',
              orderIndex: 1,
              estimatedMinutes: 30,
              content: '''# Truth Tables & De Morgan's Laws

## De Morgan's Laws:
1. `~(p ∧ q) ≡ ~p ∨ ~q`
2. `~(p ∨ q) ≡ ~p ∧ ~q`

These laws provide the direct mathematical foundation for simplifying conditional statements in software engineering.
''',
            ),
          ],
        ),
        const ModuleModel(
          id: 'mod-math-2',
          courseId: 'course-math-101',
          title: 'Module 2: Algorithmic Complexity (Big-O)',
          orderIndex: 1,
          description: 'Asymptotic growth rates, time complexity, and efficiency comparisons.',
          lessons: [
            LessonModel(
              id: 'les-math-3',
              courseId: 'course-math-101',
              moduleId: 'mod-math-2',
              title: '2.1 Definition of Big-O Notation',
              orderIndex: 0,
              estimatedMinutes: 25,
              content: '''# Asymptotic Complexity: Big-O

Big-O characterizes the upper bound of an algorithm's execution time or memory utilization as the input size `n` grows towards infinity.

## Common Complexity Classes:
- `O(1)`: Constant Time
- `O(log n)`: Logarithmic Time
- `O(n)`: Linear Time
- `O(n log n)`: Linearithmic Time (e.g., Merge Sort)
- `O(n^2)`: Quadratic Time
''',
            ),
            LessonModel(
              id: 'les-math-4',
              courseId: 'course-math-101',
              moduleId: 'mod-math-2',
              title: '2.2 Comparing Algorithm Efficiencies',
              orderIndex: 1,
              estimatedMinutes: 30,
              content: '''# Practical Efficiency Analysis

When selecting algorithms for low-bandwidth mobile devices or high-concurrency cloud servers:
- Prefer `O(n log n)` or `O(log n)` over `O(n^2)`
- Minimize redundant passes over collections
- Ensure caching of expensive recurring computations
''',
            ),
          ],
        ),
      ],
    ),
  ];

  // Global Announcements
  static final List<AnnouncementModel> sampleAnnouncements = [
    AnnouncementModel(
      id: 'ann-01',
      title: 'DLMS Platform Aligns with UN SDG 4: Quality Education',
      content: 'All foundational learning materials, quizzes, and digital certificates are provided openly to support universal, self-paced access.',
      authorName: 'System Administrator',
      authorRole: 'admin',
      priority: 'high',
      createdAt: DateTime(2026, 1, 20),
    ),
    AnnouncementModel(
      id: 'ann-02',
      title: 'Offline Reading Support Active',
      content: 'Course materials and accessed lessons are automatically cached locally so you can continue learning even during connectivity interruptions.',
      authorName: 'Academic Tech Lead',
      authorRole: 'admin',
      priority: 'normal',
      createdAt: DateTime(2026, 2, 5),
    ),
  ];
}
