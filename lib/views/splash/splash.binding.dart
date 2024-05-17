import 'package:get/get.dart';
import 'package:moneydoctor/views/splash/splash.controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
