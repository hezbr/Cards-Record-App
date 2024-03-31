import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'view/screens/splash_screen.dart';
import 'view/screens/add_batch_screen.dart';
import 'view/screens/categories_screen.dart';
import 'view/screens/operations_screen.dart';
import 'core/config/app_theme.dart';
import 'view/screens/about_app_screen.dart';
import 'view/screens/batches_screen.dart';
import 'view/screens/distributors_screen.dart';
import 'core/config/binding_all.dart';
import 'core/locale/app_locale.dart';
import 'core/locale/app_locale_controller.dart';
import 'components/main_drawer.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppLocaleController(), fenix: true);
    AppLocaleController appLocaleController = Get.find();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: appLocaleController.initialLang,
      translations: AppLocale(),
      theme: appLocaleController.initialLang.languageCode == 'ar'
          ? AppThemeAndColors.ar_lightTheme
          : AppThemeAndColors.en_lightTheme,
      initialRoute: '/mySplashScreen',
      initialBinding: BindingAll(),
      getPages: [
        GetPage(name: "/", page: () => _MyAppHome()),
        GetPage(name: "/mySplashScreen", page: () => MySplashScreen()),
        GetPage(name: "/addBatchScreen", page: () => AddBatchScreen()),
        GetPage(name: "/distributorsScreen", page: () => DistributorsScreen()),
        GetPage(name: "/aboutAppScreen", page: () => const AboutAppScreen()),
      ],
    );
  }
}

class _MyAppHome extends StatelessWidget {
  final currentScreenIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    int backButtonPressCount = 0;
    DateTime? previousBackButtonPressTime;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Obx(() => Text(currentScreenIndex.value == 0
              ? 'Operations List'.tr
              : currentScreenIndex.value == 1
                  ? 'Batches List'.tr
                  : 'Categories List'.tr))),
      body: WillPopScope(
        onWillPop: () async {
          // مفتوحة يقوم باغلاقها drawer التحقق مما اذا كانت
          if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
            Get.back();
            return false;
          }
          if (previousBackButtonPressTime == null ||
              DateTime.now().difference(previousBackButtonPressTime!) >
                  const Duration(seconds: 2)) {
            // إذا مر أكثر من ثانيتين بين النقرات، قم بإعادة تعيين العداد
            backButtonPressCount = 0;

            // إظهار إشعار التنبيه للمستخدم
            Fluttertoast.showToast(
              msg: "Press back again to exit".tr,
              toastLength: Toast.LENGTH_SHORT,
            );
          }

          // زمن النقرة السابقة على زر الرجوع
          previousBackButtonPressTime = DateTime.now();

          // زيادة العداد
          backButtonPressCount++;

          // إذا تم النقر المزدوج في ثانيتين، قم بالخروج من التطبيق
          if (backButtonPressCount == 2) {
            return true;
          }

          // عدم الخروج من التطبيق
          return false;
        },
        child: Obx(() => IndexedStack(
              index: currentScreenIndex.value,
              children: [
                OperationsScreen(),
                BatchesScreen(),
                CategoriesScreen(),
              ],
            )),
        //  GetX(
        //   init: TabsController(),
        //   builder: (controller) => controller.redirect(),
        // ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) => currentScreenIndex.value = index,
          currentIndex: currentScreenIndex.value,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: 'Home'.tr),
            BottomNavigationBarItem(
                icon: const Icon(Icons.batch_prediction), label: "Batches".tr),
            BottomNavigationBarItem(
                icon: const Icon(Icons.category), label: "Categories".tr),
            // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'.tr),
            // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'.tr),
          ],
        ),
      ),

      //
      drawer: const MainDrawer(),
    );
  }
}
