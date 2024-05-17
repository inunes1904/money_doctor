import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moneydoctor/routes/app_routes.dart';
import 'package:moneydoctor/services/storage_service.dart';

class SplashController extends GetxController {
  final storageService = StorageService();

  @override
  void onInit() async {
    super.onInit();
    await verificaSeEstaAutenticado();
  }

  Future<void> verificaSeEstaAutenticado() async {
    String? token = await storageService.readSecureData('token');

    if (token != null && token.isNotEmpty) {
      // verificar se token já expirou
      bool isTokenExpired = JwtDecoder.isExpired(token);

      FlutterNativeSplash.remove();

      if (isTokenExpired) {
        Get.offNamed(AppRoutes.home);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    } else {
        Get.offNamed(AppRoutes.login);
    }
  }
}
