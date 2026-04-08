# AppMaster - دليل البناء

## التعديلات المُجراة

### ✅ التغييرات الأساسية
| العنصر | القيمة القديمة | القيمة الجديدة |
|--------|---------------|---------------|
| اسم التطبيق | Feather | AppMaster |
| Bundle ID | thewonderofyou.Feather | com.appmastr.app |
| URL Scheme | feather:// | appmaster:// |
| رابط التبرع | GitHub Sponsors | https://t.me/AppMasterIOS |
| رابط GitHub | claration/Feather | https://t.me/AppMasterIOS |

### ✅ الأقسام المضافة
- **Home (الرئيسية)** - قسم جديد يعرض:
  - تطبيقات مميزة (Featured) - شريط أفقي
  - الأفضل (Best) - قائمة مرقمة 1-5
  - محدث مؤخراً (Recently Updated) - شريط أفقي
  - الألعاب (Games) - مفلترة تلقائياً

### ✅ اللغة العربية
- تمت إضافة **263 ترجمة عربية** كاملة
- تشمل: الواجهة، الرسائل، التعليمات، onboarding

---

## طريقة البناء في Xcode

### المتطلبات
- macOS 14+ (Sonoma أو أحدث)
- Xcode 16+
- Apple Developer Account

### خطوات البناء
```bash
# 1. افتح المشروع
open Feather.xcworkspace  # استخدم .xcworkspace وليس .xcodeproj

# 2. في Xcode:
# - اختر Team في Signing & Capabilities
# - تأكد Bundle ID: com.appmastr.app
# - اختر جهازك أو Any iOS Device
# - Product → Archive
# - Distribute App → Ad Hoc أو Developer ID
```

---

## إضافة تطبيقات للمتجر

### الطريقة الأسهل - ملف JSON على GitHub

1. **أنشئ ملف JSON** على GitHub (مثلاً: `appmaster-store.json`)
2. **استخدم هذا التنسيق:**

```json
{
  "name": "AppMaster Store",
  "identifier": "com.appmastr.store",
  "iconURL": "رابط-أيقونة-المتجر.png",
  "website": "https://t.me/AppMasterIOS",
  "tintColor": "848ef9",
  "apps": [
    {
      "name": "اسم التطبيق",
      "bundleIdentifier": "com.example.app",
      "developerName": "AppMaster",
      "iconURL": "رابط-أيقونة-التطبيق.png",
      "localizedDescription": "وصف التطبيق",
      "subtitle": "وصف قصير",
      "versions": [
        {
          "version": "1.0.0",
          "date": "2026-04-08T00:00:00Z",
          "size": 5000000,
          "downloadURL": "رابط-ملف-IPA-المباشر"
        }
      ],
      "version": "1.0.0",
      "versionDate": "2026-04-08T00:00:00Z",
      "size": 5000000,
      "downloadURL": "رابط-ملف-IPA-المباشر"
    }
  ]
}
```

3. **احصل على الرابط الخام** (Raw URL) من GitHub
4. **أضف المصدر في التطبيق:**
   - افتح AppMaster
   - اضغط Sources
   - اضغط + وأدخل الرابط الخام

### مصادر مفيدة جاهزة في التطبيق
التطبيق يأتي مُدمجاً مع مصادر AltStore الرسمية جاهزة للإضافة.

---

## ملاحظات مهمة
- ملف CoreData يبقى باسم "Feather.momd" (داخلي فقط - لا يظهر للمستخدم)
- الأيقونات القديمة لـ Feather موجودة كأيقونات بديلة - يمكنك حذفها أو الإبقاء عليها
- التطبيق يدعم iOS 18.0+

