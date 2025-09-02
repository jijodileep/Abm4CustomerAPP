# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep HTTP and networking classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-keep class com.google.gson.** { *; }
-dontwarn okhttp3.**
-dontwarn retrofit2.**

# Keep Dio HTTP client classes
-keep class dio.** { *; }
-dontwarn dio.**

# Keep all model classes (for JSON serialization)
-keep class * implements java.io.Serializable { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Flutter networking
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# General rules for release builds
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Keep line numbers for debugging stack traces
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Handle missing Google Play Core classes - comprehensive rules
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Specific rules for Play Core split compatibility
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Ignore missing Play Store split compatibility classes
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication
-dontwarn io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager**

# Keep Flutter Play Store classes but allow missing dependencies
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager** { *; }

# Additional rules for missing Play Core classes
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest**
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Keep Flutter classes that might be affected by obfuscation
-keep class io.flutter.embedding.android.FlutterActivity { *; }
-keep class io.flutter.embedding.android.FlutterApplication { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }