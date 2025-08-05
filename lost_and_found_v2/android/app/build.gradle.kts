// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.lost_and_found_v2" // Your actual package name
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.lost_and_found_v2" // Your actual package name
        minSdk = 23 // <--- CHANGE THIS LINE FROM flutter.minSdkVersion TO 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true // <--- ADD THIS LINE
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Add the Firebase BOM for consistent Firebase versions
    implementation(platform("com.google.firebase:firebase-bom:32.9.0")) // Use a recent stable version from Firebase docs

    // Add the multidex dependency
    implementation("androidx.multidex:multidex:2.0.1") // <--- ADD THIS LINE

    // Existing Flutter dependencies, usually added by flutterfire configure and pub get
    // For example:
    // implementation(project(":firebase_core"))
    // implementation(project(":firebase_auth"))
    // implementation(project(":cloud_firestore"))
    // implementation(project(":google_sign_in"))
    // implementation(project(":image_picker"))
    // implementation(project(":firebase_storage"))

    // Ensure Kotlin standard library is compatible (if not already present or managed by BOM)
    // implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.0") // This might be needed if you get Kotlin version errors
}