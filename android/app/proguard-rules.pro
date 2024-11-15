# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# PDF related rules
-keep class com.tom_roush.pdfbox.** { *; }
-keep class com.tom_roush.fontbox.** { *; }
-keep class com.tom_roush.xmpbox.** { *; }
-keep class com.tom_roush.harmony.** { *; }
-dontwarn com.tom_roush.pdfbox.**
-dontwarn com.tom_roush.fontbox.**
-dontwarn com.tom_roush.xmpbox.**
-dontwarn com.tom_roush.harmony.**

# JP2 related classes
-keep class com.gemalto.jp2.** { *; }
-dontwarn com.gemalto.jp2.**

# Apache Commons
-keep class org.apache.commons.** { *; }
-dontwarn org.apache.commons.**

# Additional keeps
-keep class javax.measure.** { *; }
-dontwarn javax.measure.**
-keep class android.support.v8.renderscript.** { *; }
-keep class androidx.renderscript.** { *; }

# Keep your application's model classes
-keep class com.technova15.cheat_ai.models.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# Multidex
-keep class androidx.multidex.** { *; }