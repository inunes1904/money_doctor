import 'package:get/get.dart';

import 'investimentos.controller.dart';

class InvestimentosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestimentosController>(
      () => InvestimentosController(),
    );
  }
}
