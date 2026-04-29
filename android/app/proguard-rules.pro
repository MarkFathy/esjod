# Flutter ProGuard Rules

# ============================================
# Flutter Local Notifications - Critical Rules
# ============================================
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# Required by flutter_local_notifications for JSON serialization
-keep class com.google.gson.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }

# Keep specific notification receivers explicitly
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver { *; }
-keep class com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver { *; }
-keep class com.dexterous.flutterlocalnotifications.NotificationBroadcastReceiver { *; }

# ============================================
# Geolocator
# ============================================
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.** { *; }
-dontwarn com.baseflow.geolocator.**

# ============================================
# Just Audio & Audio Service
# ============================================
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.ryanheise.** { *; }
-dontwarn com.ryanheise.just_audio.**
-dontwarn com.ryanheise.audioservice.**

# Keep just_audio Java classes
-keep class * extends com.ryanheise.just_audio.AudioPlayer { *; }
-keepclassmembers class com.ryanheise.just_audio.AudioPlayer {
    <init>(...);
    <fields>;
    <methods>;
}

# Keep audio session and ExoPlayer classes used by just_audio
-keep class com.google.android.exoplayer2.** { *; }
-keep class androidx.media2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-dontwarn androidx.media2.**

# ============================================
# Shared Preferences
# ============================================
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# ============================================
# Android Alarm Manager (if still referenced)
# ============================================
-keep class dev.fluttercommunity.plus.androidalarmmanager.** { *; }
-dontwarn dev.fluttercommunity.plus.androidalarmmanager.**

# ============================================
# AndroidX Media
# ============================================
-keep class androidx.media.** { *; }
-keep class androidx.media.session.** { *; }
-keep class android.support.v4.media.** { *; }
-dontwarn androidx.media.**

# ============================================
# General Android Notification Framework
# ============================================
-keep class android.app.Notification { *; }
-keep class android.app.Notification$Builder { *; }
-keep class android.app.NotificationChannel { *; }
-keep class android.app.NotificationManager { *; }
-keep class android.app.PendingIntent { *; }
-keep class android.app.AlarmManager { *; }
-keep class android.content.BroadcastReceiver { *; }

# ============================================
# Keep ALL BroadcastReceivers and Services
# ============================================
-keep class * extends android.content.BroadcastReceiver {
    <init>();
    void onReceive(android.content.Context, android.content.Intent);
}
-keep class * extends android.app.Service {
    <init>();
}

# ============================================
# Flutter Framework
# ============================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# ============================================
# Keep native methods
# ============================================
-keepclasseswithmembernames class * {
    native <methods>;
}

# ============================================
# Keep Parcelable and Serializable
# ============================================
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
-keep class * implements java.io.Serializable { *; }

# ============================================
# Google Play Core - dont warn (not needed for APK)
# ============================================
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# ============================================
# Keep attributes
# ============================================
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations
-keepattributes MethodParameters
-keepattributes LocalVariableTable
-keepattributes LocalVariableTypeTable
-keepattributes Deprecated
