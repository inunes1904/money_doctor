import 'package:get/get.dart';

import 'registo.controller.dart';

class RegistoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistoController>(
      () => RegistoController(),
    );
  }
}
