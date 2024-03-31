import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => Get.offNamed('/'));
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(    
        backgroundColor: Get.isPlatformDarkMode? Colors.black: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/splashIcon.png',
                fit: BoxFit.contain, 
                width: Get.mediaQuery.size.width-150,
                height: Get.mediaQuery.size.height*2.5/6,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.93),
              child: Image.asset(
                'assets/images/${Get.isPlatformDarkMode?'white':'black'}Logo.png',
                height: Get.mediaQuery.size.height/24, //70
                // width: Get.width, // 110,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
    );
  }
}