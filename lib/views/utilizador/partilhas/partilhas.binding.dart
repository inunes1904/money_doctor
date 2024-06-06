import 'package:get/get.dart';

import 'partilhas.controller.dart';

class PartilhasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartilhasController>(
      () => PartilhasController(),
    );
  }
}
