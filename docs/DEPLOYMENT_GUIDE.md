# PRODUCTION DEPLOYMENT & DISTRIBUTION GUIDE
# Digital Learning Management System (DLMS)

## 1. Overview
This guide provides precise, reproducible instructions for deploying the **Digital Learning Management System (DLMS)** to:
1. **Target A: Flutter Web & Firebase Hosting** (Global CDN with SSL and SPA routing)
2. **Target B: Android APK & Google Play Distribution** (Release build, Keystore signing, and permissions)

---

## 2. Target A: Flutter Web & Firebase Hosting

### Step 1: Compile Production Web Artifacts
Execute the Flutter build command using the release profile:
```bash
flutter build web --release
```
*Build Artifact Location:* `build/web/`  
*Contents:* `index.html`, `main.dart.js`, `flutter_bootstrap.js`, `assets/`, `manifest.json`.

### Step 2: Verify SPA & Cache Rules in `firebase.json`
DLMS includes a pre-configured `firebase.json` with Single Page Application rewrites to ensure deep links (e.g. `/course-details/course-python-101`) resolve cleanly upon page refresh:
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

### Step 3: Authenticate & Deploy
Run the Firebase CLI commands:
```bash
# 1. Log in to Firebase account
npx -y firebase-tools login

# 2. Select active project
npx -y firebase-tools use --add

# 3. Deploy hosting, Firestore security rules, and Storage rules
npx -y firebase-tools deploy
```
*Live Hosting URL:* `https://<YOUR-PROJECT-ID>.web.app`

---

## 3. Target B: Android Deployment & Distribution

### Step 1: Prerequisites
- Android SDK (API Level 23 to 34 supported)
- Java Development Kit (JDK 17 or higher recommended for Gradle builds)

### Step 2: Unsigned Release APK Build (Testing & Internal Sideloading)
To build an APK for immediate testing on devices without private signing keys:
```bash
flutter build apk --release
```
*Output Location:* `build/app/outputs/flutter-apk/app-release.apk`

### Step 3: Production Signed APK / Android App Bundle (AAB)

#### 1. Generate Keystore File
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload -storetype JKS
```

#### 2. Configure Key Properties (`android/key.properties`)
Create `android/key.properties` (this file is excluded from Git in `.gitignore` to protect credentials):
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

#### 3. Update `android/app/build.gradle.kts`
Configure the signing configuration in Gradle:
```kotlin
android {
    ...
    signingConfigs {
        create("release") {
            val keyPropertiesFile = rootProject.file("key.properties")
            val keyProperties = Properties()
            if (keyPropertiesFile.exists()) {
                keyProperties.load(FileInputStream(keyPropertiesFile))
            }
            keyAlias = keyProperties.getProperty("keyAlias")
            keyPassword = keyProperties.getProperty("keyPassword")
            storeFile = keyProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keyProperties.getProperty("storePassword")
        }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

#### 4. Compile Signed Android App Bundle (AAB)
```bash
flutter build appbundle --release
```
*Output Location:* `build/app/outputs/bundle/release/app-release.aab`  
Submit this file directly to the Google Play Developer Console.

---

## 4. Local Web Server Preview
To test the built production web files locally without Firebase:
```bash
# Using Python
cd build/web
python -m http.server 8080

# Or using Node.js serve
npx serve build/web
```
Access at `http://localhost:8080`.
