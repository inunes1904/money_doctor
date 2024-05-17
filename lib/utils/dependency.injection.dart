import 'package:get/get.dart';
// import '../views/network/network.controller.dart';
import '../views/splash/splash.controller.dart';

class DependencyInjection {
  static void init() async {
    //services
    // Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<SplashController>(SplashController(), permanent: true);
  }
}
