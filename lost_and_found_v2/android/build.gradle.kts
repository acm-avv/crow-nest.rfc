// lost_and_found_v2/android/build.gradle.kts

// START: REQUIRED buildscript block
buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // Define the Kotlin version directly here
        // Android Gradle Plugin (AGP) - check your current version if different
        classpath("com.android.tools.build:gradle:8.4.1") // Example AGP version

        // Kotlin Gradle Plugin - directly specify the version
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0") // <--- CORRECTED LINE

        // Google Services plugin (for Firebase) - check your current version if different
        classpath("com.google.gms:google-services:4.4.1") // Example Google Services version
    }
}
// END: REQUIRED buildscript block

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}