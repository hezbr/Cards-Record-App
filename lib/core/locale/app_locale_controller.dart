import 'package:flutter/material.dart' show Locale;
import 'package:cards_record/core/config/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AppLocaleController extends GetxController{
  SharedPreferences? prefs;
  
  // متغير سيتم فيه تخزين مفتاح اللغة للمستخدم
  Locale initialLang = Get.deviceLocale?? const Locale('ar');

  // تعريف متغير من اجل التحكم بازرار اختيار اللغة
  RxString selectedLang= "".obs;
  
  @override
  void onInit() async{
    // استرجاع اللغة المخزنة للمستخدم والا ناخذ لغة الجهاز
    prefs= await SharedPreferences.getInstance();
    String langKey= prefs!.getString('langKey')?? 'dl';
    initialLang = (langKey== 'dl'? Get.deviceLocale?? const Locale('ar'): Locale(langKey));
    selectedLang.value= langKey;

    // تحديث اللغة والثيم المناسب للغة
    Get.updateLocale(initialLang);
    Get.changeTheme(selectedLang == 'ar'? AppThemeAndColors.ar_lightTheme: AppThemeAndColors.en_lightTheme);
    super.onInit();
  }

  void changeLanguage(String langKey) {
    selectedLang.value= langKey;
    prefs!.setString('langKey', langKey);
    initialLang = (langKey== 'dl'? Get.deviceLocale?? const Locale('ar'): Locale(langKey));
    Get.updateLocale(initialLang);
    Get.changeTheme(selectedLang == 'ar'? AppThemeAndColors.ar_lightTheme: AppThemeAndColors.en_lightTheme);
  }
}