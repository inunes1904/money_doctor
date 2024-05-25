import 'package:get/get.dart';
import 'relatorios.controller.dart';

class RelatoriosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RelatoriosController>(
      () => RelatoriosController(),
    );
  }
}
