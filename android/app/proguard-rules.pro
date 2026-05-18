## Flutter ProGuard Rules

# ============================================
# Flutter Framework & Engine
# ============================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

-keep class io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class com.fourthpyramid.esjodapp.** { *; }

# Keep native methods for JNI
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable and Serializable
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
-keep class * implements java.io.Serializable { *; }

# Keep attributes for reflection and annotations
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

# ============================================
# Awesome Notifications
# ============================================
-keep class me.carda.awesome_notifications.** { *; }
-dontwarn me.carda.awesome_notifications.**
-keep class * extends me.carda.awesome_notifications.notifications.broadcasters.NotificationBroadcastReceiver { *; }
-keep class * extends me.carda.awesome_notifications.notifications.broadcasters.ScheduledNotificationReceiver { *; }
-keep class * extends me.carda.awesome_notifications.notifications.broadcasters.BootBroadcastReceiver { *; }
-keep class me.carda.awesome_notifications.models.** { *; }

# ============================================
# Just Audio & Audio Service
# ============================================
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audioservice.** { *; }
-dontwarn com.ryanheise.just_audio.**
-dontwarn com.ryanheise.audioservice.**
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# ============================================
# WorkManager - Background Task Execution
# ============================================
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
-keep class androidx.work.impl.** { *; }
-keep class androidx.work.impl.foreground.SystemForegroundService { *; }
-keep class dev.fluttercommunity.workmanager.** { *; }
-dontwarn dev.fluttercommunity.workmanager.**
-keep class be.tramckrijte.workmanager.** { *; }

# ============================================
# Android Alarm Manager Plus
# ============================================
-keep class dev.fluttercommunity.plus.androidalarmmanager.** { *; }
-dontwarn dev.fluttercommunity.plus.androidalarmmanager.**

# ============================================
# Android Intent Plus
# ============================================
-keep class io.flutter.plugins.androidintentplus.** { *; }
-dontwarn io.flutter.plugins.androidintentplus.**

# ============================================
# Geolocator
# ============================================
-keep class com.baseflow.geolocator.** { *; }
-dontwarn com.baseflow.geolocator.**

# ============================================
# Shared Preferences
# ============================================
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# ============================================
# General Android Framework & Media
# ============================================
-keep class androidx.media.** { *; }
-dontwarn androidx.media.**
-keep class android.support.v4.media.** { *; }
-keep class com.google.gson.** { *; }

# ============================================
# Play Core (Required for some plugins and AGP 8.x)
# ============================================
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

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
# Upgrader
# ============================================
-keep class com.it_nomads.flutter_upgrader.** { *; }
-dontwarn com.it_nomads.flutter_upgrader.**

# ============================================
# General Suppressions for AGP 8.x / R8
# ============================================
-ignorewarnings
-dontnote **
