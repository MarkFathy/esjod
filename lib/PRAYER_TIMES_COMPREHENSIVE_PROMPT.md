# 📱 موجز شامل لميزة مواقيت الصلاة

## 🎯 نظرة عامة
ميزة مواقيت الصلاة تقدم للمستخدم:
- **عرض جدول مواقيت الصلاة** لليوم الحالي والأيام القادمة
- **إشعارات ذكية** لكل وقت صلاة (مع إمكانية تفعيل/تعطيل كل صلاة على حدة)
- **عد تنازلي مباشر** للصلاة القادمة مع عرض الصلاة السابقة
- **معالجة في الخلفية** باستخدام WorkManager لجدولة الإشعارات تلقائياً حتى عند إغلاق التطبيق

---

## 📊 البنية المعمارية (Clean Architecture)

### 1. **Presentation Layer** - طبقة العرض
**المسار:** `lib/features/prayer_times/presentation/`

#### المكونات الرئيسية:

**a) Views (الواجهات)**
- `prayer_times_view.dart` - الشاشة الرئيسية
  - تعرض جدول مواقيت الصلاة
  - تتعامل مع حالات النجاح والفشل
  - تستخدم `BlocSelector` لكفاءة الأداء
  - تتضمن زر تحديث يدوي

**b) Widgets (المكونات)**
- `current_prayer_card_widget.dart` - البطاقة الرئيسية
  - عرض الصلاة الحالية/القادمة
  - عداد دائري (Circular Progress) يعرض الوقت المتبقي
  - معلومات التاريخ الهجري والميلادي
  - اسم اليوم والمدينة
  - زر تحديث الموقع

**c) Cubit (إدارة الحالة)**
- `prayer_times_cubit.dart` - يدير كل منطق الصلاة
  - جلب مواقيت الصلاة
  - جدولة الإشعارات
  - حساب الصلاة القادمة
  - تحديث العد التنازلي كل ثانية
  - معالجة الصلاحيات

- `prayer_times_state.dart` - الحالة
  ```dart
  class PrayerTimesState {
    final RequestStatus status;
    final LocalPrayerTimes? localPrayerTimes;
    final PrayerType? nextPrayer;
    final Duration? timeLeft;
    final DateTime? previousPrayerDateTime;
    final DateTime lastUpdated;
    final String? message;
    final String city;
  }
  ```

**d) Helpers (المساعدات)**
- `notification_constants.dart` - ثوابت الإشعارات
  - معلومات القناة: `prayerChannelKey`, `prayerChannelName`
  - صوت الأذان: `azan` من `assets/`
  - أيقونة: `resource://drawable/ic_muslim_logo`
  - التكرار: كل 12 ساعة
  - عدد أيام الجدولة: 3 أيام مقدماً

- `time_left_format.dart` - تنسيق الوقت المتبقي
  - تحويل `Duration` إلى صيغة قابلة للقراءة (ساعة:دقيقة:ثانية)

- `prayer_consts.dart` - ثوابت الصلوات
  - تعريفات الصلوات الخمس + الجمعة

---

### 2. **Domain Layer** - طبقة المنطق

**المسار:** `lib/features/prayer_times/domain/`

#### الكيانات (Entities):

**a) `local_prayer_times.dart`**
```dart
class LocalPrayerTimes {
  final String fajr;        // الفجر
  final String sunrise;     // الشروق
  final String dhuhr;       // الظهر
  final String asr;         // العصر
  final String maghrib;     // المغرب
  final String isha;        // العشاء
  final String city;
  final DateTime date;
  
  // DateTime objects للجدولة الدقيقة
  final DateTime? fajrDateTime;
  final DateTime? sunriseDateTime;
  // ... إلخ
}
```
**الهدف:** تخزين مواقيت صلاة يوم واحد
- الأوقات كـ strings (للعرض) و DateTime (للجدولة)

**b) `prayer_notification_settings.dart`**
```dart
class PrayerNotificationSettings {
  final bool fajrEnabled;    // true by default
  final bool dhuhrEnabled;   // true by default
  final bool asrEnabled;     // true by default
  final bool maghribEnabled; // true by default
  final bool ishaEnabled;    // true by default
  final bool jumuahEnabled;  // true by default
}
```
**الهدف:** إعدادات الإشعارات لكل صلاة على حدة

**c) `prayer_type.dart`**
```dart
enum PrayerType {
  fajr,     // الفجر
  sunrise,  // الشروق
  dhuhr,    // الظهر
  asr,      // العصر
  maghrib,  // المغرب
  isha,     // العشاء
  jumuah    // الجمعة
}
```
- بعض الصلوات لا تملك أذاناً (مثل الشروق)

**d) `prayer_calculation_result.dart`**
```dart
class PrayerCalculationResult {
  final PrayerType? nextPrayer;
  final Duration? timeLeft;
  final DateTime? previousPrayerDateTime;
}
```

#### Use Cases (حالات الاستخدام):

- `get_prayer_times_usecase.dart` - جلب مواقيت اليوم الحالي
- `get_prayer_times_for_date_usecase.dart` - جلب مواقيت لتاريخ محدد
- `get_cached_coordinates_usecase.dart` - جلب الإحداثيات المحفوظة
- `schedule_notifications_usecase.dart` - جدولة الإشعارات
- `get_notification_settings_usecase.dart` - جلب إعدادات الإشعارات
- `set_prayer_enabled_usecase.dart` - تفعيل/تعطيل إشعار صلاة معينة
- `calculate_next_prayer_usecase.dart` - حساب الصلاة القادمة والوقت المتبقي

---

### 3. **Data Layer** - طبقة البيانات

**المسار:** `lib/features/prayer_times/data/`

#### Data Sources (مصادر البيانات):

**a) `prayer_times_local_data_source.dart`**
- جلب مواقيت الصلاة من API أو المحفوظ
- تخزين الإحداثيات مؤقتاً
- دعم اللغتين العربية والإنجليزية

**b) `prayer_notification_local_data_source.dart`**
```dart
Future<void> scheduleAll(
  List<LocalPrayerTimes> days,
  PrayerNotificationSettings settings,
) async {
  // 1. مسح الإشعارات القديمة
  await cancelAll();
  
  // 2. جدولة إشعار لكل صلاة في الأيام المطلوبة
  for (final times in days) {
    for (final prayer in PrayerType.values) {
      if (!settings.isEnabled(prayer)) continue;
      await _scheduleSinglePrayer(...);
    }
  }
}
```
**الهدف:** 
- جدولة إشعارات باستخدام Awesome Notifications
- إلغاء الإشعارات القديمة
- تخطي الصلوات المعطلة من المستخدم

#### Repositories (المستودعات):
- تطبيق Repository Pattern
- تحويل البيانات من Local Data Sources

---

## 🔔 نظام الإشعارات (Notifications System)

### 1. **إعدادات القناة**
```dart
// القناة الأساسية للإشعارات
prayerChannelKey = 'prayer_reminder'
prayerChannelName = 'تذكير الصلاة'
prayerChannelColor = Color(0xFF33A1E0) // أزرق
prayerSoundSource = 'resource://raw/azan' // ملف الأذان
notificationIcon = 'resource://drawable/ic_muslim_logo'
```

### 2. **إنشاء قنوات الإشعارات**
**الملف:** `notification_channel_factory.dart`
```dart
NotificationChannel createPrayerChannel() {
  return NotificationChannel(
    channelKey: NotificationConstants.prayerChannelKey,
    channelName: NotificationConstants.prayerChannelName,
    channelDescription: NotificationConstants.prayerChannelDescription,
    importance: NotificationImportance.High,
    soundSource: NotificationConstants.prayerSoundSource,
    defaultColor: NotificationConstants.prayerChannelColor,
    enableVibration: true,
  );
}
```

### 3. **عملية الجدولة**
```
1. تحميل إعدادات الإشعارات (أي الصلوات مفعلة)
2. جلب مواقيت 3 أيام قادمة
3. لكل يوم، لكل صلاة:
   - تحقق من الإعداد (مفعل أم معطل)
   - إذا كانت الصلاة مستقبلية (لم تمضِ بعد):
     - جدول إشعار باستخدام Awesome Notifications
4. إذا لم يتم جدولة أي شيء، جدول إشعار تحديث احتياطي
```

### 4. **معرف الإشعار**
```dart
// يتم حساب معرف فريد لكل إشعار:
notificationId = prayer.id * 1000 + dayIndex
// مثال: Fajr (0) في اليوم الأول = 0
//       Dhuhr (2) في اليوم الثاني = 2001
```

### 5. **إشعار التحديث الاحتياطي**
- إذا لم يتم جدولة أي إشعارات
- يعرض للمستخدم: "تحقق من مواقيت الصلاة"
- يتم تشغيله بعد 3 أيام

---

## 🔄 معالجة الخلفية (Background Processing)

**الملف الرئيسي:** `prayer_work_manager_data_source.dart`

### 1. **WorkManager Setup**
```dart
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == PeriodicReminderConstants.workManagerTaskName) {
      return await _handlePeriodicReminderTask();
    } else {
      return await _handlePrayerTimesTask();
    }
  });
}
```

### 2. **مهمة مواقيت الصلاة**
```dart
Future<bool> _handlePrayerTimesTask() async {
  // 1. تهيئة الإشعارات في العزلة
  await AwesomeNotifications().initialize(...);
  
  // 2. جلب الإحداثيات المحفوظة
  final cachedCoords = await prayerDataSource.getCachedCoordinates();
  
  // 3. جلب مواقيت 3 أيام قادمة
  for (int i = 0; i < scheduleDaysAhead; i++) {
    final times = await prayerDataSource.getPrayerTimesForDate(...);
    upcomingDaysTimes.add(times);
  }
  
  // 4. جدولة جميع الإشعارات
  await notificationDataSource.scheduleAll(upcomingDaysTimes, settings);
  
  return true;
}
```

### 3. **معدل تكرار المهمة**
- **التكرار:** كل 12 ساعة
- **التأخير الأولي:** 15 دقيقة (بعد بدء التطبيق)
- **المعرّف الفريد:** `updatePrayerTimes`

### 4. **الفائدة**
✅ تحديث جداول الإشعارات تلقائياً
✅ حتى عند إغلاق التطبيق بالكامل
✅ موثوقية عالية في تسليم الإشعارات

---

## 📋 جدول الشاشة الرئيسية

### المكونات البصرية:

```
┌─────────────────────────────────────────┐
│ الثلاثاء - 15 شعبان 1447 هـ            │
│ مكة المكرمة 🔄                          │
├─────────────────────────────────────────┤
│                                         │
│         ⭕ الوقت المتبقي              │
│         (أذان يومي)                    │
│         دقيقة : ثانية : ثانية          │
│                                         │
│     التالية: الظهر 12:23               │
│     السابقة: الفجر 04:45               │
│                                         │
├─────────────────────────────────────────┤
│ الفجر      04:45  ✓                    │
│ الشروق     06:15  ✓                    │
│ الظهر      12:23  ⏳ (القادمة)        │
│ العصر      15:45  ⏸                   │
│ المغرب     18:50  ⏸                   │
│ العشاء     20:10  ⏸                   │
└─────────────────────────────────────────┘
```

### حالات الشاشة:

**1. حالة التحميل (Loading)**
- عرض Skeletonizer (عظام الهيكل)
- إظهار العناصر بشكل رمادي متحرك

**2. حالة النجاح (Success)**
- عرض الجدول الكامل
- تحديث العد التنازلي كل ثانية
- خلفية بتدرج اللون الأزرق

**3. حالة الفشل (Failure)**
- رسالة خطأ مركزية
- زر "إعادة محاولة"
- الأسباب الشائعة:
  - لم يتم منح صلاحية الموقع
  - انقطاع الإنترنت
  - مشكلة في الحصول على الإحداثيات

---

## ⏱️ نظام العد التنازلي (Countdown System)

### آلية العمل:

```dart
// في الـ Cubit:
_startCountdown() {
  _timer?.cancel();
  
  // تحديث كل ثانية
  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    _updateCountdown();
  });
}

void _updateCountdown() {
  // 1. حساب الصلاة القادمة والوقت المتبقي
  final calculation = _calculateNextPrayer.calculateSync(currentTimes);
  
  // 2. تحديث الحالة فقط عند تغيير مهم
  if (shouldEmit) {
    emit(state.copyWith(
      nextPrayer: calculation.nextPrayer,
      timeLeft: calculation.timeLeft,
    ));
  }
}
```

### الحسابات:

```dart
class CalculateNextPrayerUseCase {
  PrayerCalculationResult calculateSync(LocalPrayerTimes times) {
    final now = DateTime.now();
    
    // ترتيب الصلوات
    final prayerOrder = [
      PrayerType.fajr,
      PrayerType.dhuhr,
      PrayerType.asr,
      PrayerType.maghrib,
      PrayerType.isha,
    ];
    
    // ابحث عن أول صلاة مستقبلية
    for (final prayer in prayerOrder) {
      final time = times.dateTimeForPrayer(prayer);
      if (time != null && time.isAfter(now)) {
        return PrayerCalculationResult(
          nextPrayer: prayer,
          timeLeft: time.difference(now),
          previousPrayerDateTime: previousTime,
        );
      }
    }
    
    // إذا انتهت كل الصلوات، الصلاة التالية هي فجر الغد
    return PrayerCalculationResult(
      nextPrayer: PrayerType.fajr,
      timeLeft: calculateTimeUntilTomorrow(),
    );
  }
}
```

---

## 🎛️ إعدادات الإشعارات

### الملف: `settings_service.dart`

```dart
// المسار: lib/features/settings/service/settings_service.dart

// جلب إعدادات الإشعارات لكل صلاة
Future<PrayerNotificationSettings> getPrayerNotificationSettings() async {
  // يتم جلبها من SharedPreferences
  return PrayerNotificationSettings(
    fajrEnabled: true,      // يمكن للمستخدم تعطيلها
    dhuhrEnabled: true,
    asrEnabled: true,
    maghribEnabled: true,
    ishaEnabled: true,
    jumuahEnabled: true,
  );
}

// تفعيل/تعطيل إشعار صلاة معينة
Future<void> setPrayerNotificationEnabled(
  PrayerType type,
  bool enabled,
) async {
  final settings = await getPrayerNotificationSettings();
  final updated = settings.copyWithPrayer(type, enabled: enabled);
  await _sharedPreferences.setString('prayer_settings', json.encode(updated));
}
```

---

## 🏗️ Flow الكامل (من البداية إلى النهاية)

### 1. **عند فتح التطبيق:**
```
1. PrayerTimesView.initState()
   ↓
2. context.read<PrayerTimesCubit>().checkInitialData()
   ↓
3. تحقق: هل البيانات محملة؟
   - نعم → توقف
   - لا → اذهب للخطوة 4
   ↓
4. init() → تحميل الإعدادات + جلب المواقيت
   ↓
5. fetchPrayerTimes() → جلب مواقيت اليوم
   ↓
6. احصل على الإحداثيات المحفوظة
   ↓
7. اجلب مواقيت 3 أيام قادمة
   ↓
8. scheduleNotifications() → جدولة الإشعارات
   ↓
9. _startCountdown() → بدء العد التنازلي (كل ثانية)
   ↓
10. تحديث الواجهة بالصلاة القادمة والوقت المتبقي
```

### 2. **عند حدوث تنبيه الصلاة:**
```
1. يتم إطلاق الإشعار بصوت الأذان
2. ظهور نافذة الإشعار على شاشة الجهاز
3. المستخدم يفتح التطبيق
4. الواجهة تنتقل تلقائياً لتابع الصلاة الحالية
```

### 3. **كل 12 ساعة في الخلفية:**
```
1. WorkManager يستدعي callbackDispatcher()
2. _handlePrayerTimesTask() يعمل في العزلة
3. جلب الإحداثيات ومواقيت 3 أيام
4. إعادة جدولة الإشعارات
5. تحديث قائمة الإشعارات للأيام الجديدة
```

---

## 📱 الصلاحيات المطلوبة

```yaml
# android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

# ios/Runner/Info.plist
NSLocationWhenInUseUsageDescription: "لعرض مواقيت الصلاة الدقيقة"
NSLocationAlwaysAndWhenInUseUsageDescription: "للإشعارات الموثوقة في الخلفية"
```

---

## 🧪 حالات الاختبار المهمة

1. ✅ تحديث الإشعارات عند تغيير الإعدادات
2. ✅ عدم إطلاق إشعار لصلاة مضت بالفعل
3. ✅ الانتقال الصحيح من صلاة لأخرى تمام الوقت
4. ✅ عمل الإشعارات حتى مع إغلاق التطبيق
5. ✅ جدولة دقيقة مع فروقات المناطق الزمنية
6. ✅ تحديث الجدول عند تغيير الموقع

---

## 📁 ملخص البنية

```
lib/features/prayer_times/
├── presentation/
│   ├── cubit/
│   │   ├── prayer_times_cubit.dart
│   │   └── prayer_times_state.dart
│   ├── views/
│   │   ├── prayer_times_view.dart
│   │   └── widgets/
│   │       └── current_prayer_card_widget.dart
│   └── helper/
│       ├── notification_constants.dart
│       ├── notification_channel_factory.dart
│       ├── prayer_consts.dart
│       └── time_left_format.dart
├── domain/
│   ├── entities/
│   │   ├── local_prayer_times.dart
│   │   ├── prayer_notification_settings.dart
│   │   ├── prayer_type.dart
│   │   └── prayer_calculation_result.dart
│   ├── repositories/
│   │   └── prayer_times_repository.dart
│   └── usecases/
│       ├── get_prayer_times_usecase.dart
│       ├── get_prayer_times_for_date_usecase.dart
│       ├── calculate_next_prayer_usecase.dart
│       ├── schedule_notifications_usecase.dart
│       └── ...
└── data/
    ├── datasources/
    │   ├── prayer_times_local_data_source.dart
    │   ├── prayer_notification_local_data_source.dart
    │   └── prayer_work_manager_data_source.dart
    └── repositories/
        └── prayer_times_repository_impl.dart
```

---

## 🔌 المكتبات المستخدمة

- **Flutter BLoC** - إدارة الحالة
- **Awesome Notifications** - الإشعارات المحلية
- **WorkManager** - المهام الدورية في الخلفية
- **Equatable** - مساواة الكائنات
- **Hijri Calendar** - التاريخ الهجري
- **Intl** - الترجمة والتواريخ

---

**تم توثيق هذا الملف:** 2026-05-17
**الإصدار:** 1.0
