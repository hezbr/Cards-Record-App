import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/installment_controller.dart';
import '../core/locale/app_locale_controller.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget buildListTile(String text, IconData icon, Function tapHandler) {
    return Builder(builder: (context) {
      return ListTile(
        leading: Icon(
          icon,
          color: Get.theme.iconTheme.color,
          size: (1.55 * Get.textTheme.titleMedium!.fontSize!),
        ),
        title: Text(
          text.tr,
          style: Get.textTheme.titleMedium,
        ),
        onTap: () => tapHandler(),
      );
    });
  }

  Widget buildRadioLTForLanguage(String title, String value, AppLocaleController controller) {
    return Obx(
      () => RadioListTile(
        title: Text(title.tr),
        value: value,
        activeColor: Get.theme.primaryColor,
        groupValue: controller.selectedLang.value,
        onChanged: (value) => controller.changeLanguage(value ?? 'ar'),
      ),
    );
  }

  Widget buildExpandedList() {
    final AppLocaleController localeController = Get.find();
    return ExpansionTile(
      leading: Icon(
        Icons.language,
        color: Get.theme.iconTheme.color,
        size: (1.55 * Get.textTheme.titleMedium!.fontSize!),
      ),
      title: Text("Language".tr, style: Get.textTheme.titleMedium),
      children: [
        buildRadioLTForLanguage("Device Language", "dl", localeController),
        buildRadioLTForLanguage("English", "en", localeController),
        buildRadioLTForLanguage("Arabic", "ar", localeController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            color: Theme.of(context).colorScheme.secondary,
            alignment: Alignment.center,
            // padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 45),
                Text(
                  "Cards Record!".tr,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),            
          ),
          buildListTile("Main", Icons.home, () => Get.offNamed('/')),
          buildListTile("Add Batch", Icons.add_box_sharp, () => Get.offNamedUntil(
                  "/addBatchScreen", (route) => route.settings.name == '/')),
          buildListTile("Pay Installment", Icons.attach_money_outlined, () async{
            Get.back();
            Get.find<InstallmentController>().buildInstallmentDialog();            
          }),
          buildListTile("Distributors", Icons.people, () => Get.offNamedUntil(
            "/distributorsScreen", (route) => route.isFirst)),
          buildListTile("Theme", Icons.color_lens, () {
            Get.defaultDialog(
                title: "",
                titlePadding: const EdgeInsets.all(0),
                middleText: "This feature is not currently available.".tr);
          }),
          buildExpandedList(),
          buildListTile("About App & Developer", Icons.person_2_rounded,
              () => Get.offNamedUntil('/aboutAppScreen', (route) => route.isFirst)),
        ],
      ),
    );
  }
}
