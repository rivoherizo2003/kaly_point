pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// plugins {
//     id("dev.flutter.flutter-plugin-loader") version "1.0.0"
//     id("com.android.application") version "8.11.1" apply false
//     id("org.jetbrains.kotlin.android") version "2.2.20" apply false
// }

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    
    // On passe de 8.11.1 (trop récent/instable) à 8.3.2 (très stable avec Java 17)
    id("com.android.application") version "8.3.2" apply false
    
    // On passe de 2.2.20 à 1.9.24 (le standard actuel pour éviter les bugs du compilateur K2)
    // Tu pourras repasser à la v2 plus tard une fois le build stabilisé.
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}

include(":app")
