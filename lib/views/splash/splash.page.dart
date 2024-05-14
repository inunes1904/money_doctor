import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneydoctor/styles/global.colors.dart';
import 'package:moneydoctor/views/splash/splash.controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalColors.mainColor,
        body: Center(
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
