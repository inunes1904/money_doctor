import 'package:get/get.dart';
import 'recuperarpass.controller.dart';

class RecuperarPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecuperarPassController>(
      () => RecuperarPassController(),
    );
  }
}
