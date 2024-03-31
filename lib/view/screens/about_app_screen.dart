import 'package:flutter/material.dart'
    show
        AppBar,
        AssetImage,
        BoxDecoration,
        BoxFit,
        BoxShape,
        BuildContext,
        Center,
        Colors,
        Column,
        Container,
        DecorationImage,
        DefaultTextStyle,
        EdgeInsets,
        Icon,
        Icons,
        MainAxisAlignment,
        Scaffold,
        SingleChildScrollView,
        StatelessWidget,
        Text,
        TextAlign,
        TextButton,
        TextDirection,
        Widget;
import 'package:flutter/src/widgets/basic.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;

import '../../components/main_drawer.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About App & Developer".tr)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Application Developer".tr,
                  style: Get.textTheme.titleLarge,
                ),
              ),
              Container(
                width: 165,
                height: 200,
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor.withAlpha(180),
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/developerImage.jpg'),
                      fit: BoxFit.contain,
                    )),
              ),
              DefaultTextStyle(
                style:
                    Get.textTheme.titleMedium!.copyWith(color: Colors.black45),
                child: Column(
                  children: [
                    Text(
                      "His name is Hezbr Al-humaidi,".tr,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                        "Holds a Bachelor's degree in information Technology,"
                            .tr,
                        textAlign: TextAlign.center),
                    Text("at Ibb University.".tr, textAlign: TextAlign.center),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'eng.hezbr@gmail.com',
                    queryParameters: {'subject': "Hello,Mr.Hezbr"},
                  );
                  try {
                    await launchUrl(emailLaunchUri);
                  } catch (e) {
                    print('Could not launch email: $e');
                  }
                },
                icon: const Icon(Icons.email, size: 22),
                label: const Text('eng.hezbr@gmail.com',
                    textDirection: TextDirection.ltr),
              ),
              TextButton.icon(
                onPressed: () async {
                  final Uri phoneLaunchUri = Uri(
                    scheme: 'tel',
                    path: '+967717317241',
                  );

                  try {
                    await launchUrl(phoneLaunchUri);
                  } catch (e) {
                    print('Could not launch phone: $e');
                  }
                },
                icon: const Icon(Icons.phone, size: 22),
                label: const Text('+967 717317241',
                    textDirection: TextDirection.ltr),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "About Application".tr,
                  style: Get.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "This application is intended for the general public who deal with cards of various types, to regulate their dealings with cards taken from various distributors, as well as debts for cards, installments, and other organizing various transactions with cards, whether network cards, credit cards, or others.".tr,
                  style: Get.textTheme.titleSmall!.copyWith(
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}
