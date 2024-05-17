import 'package:get/get.dart';

import 'suporte.controller.dart';

class SuporteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuporteController>(
      () => SuporteController(),
    );
  }
}
