import 'package:get/get.dart';
import 'orcamentos.controller.dart';

class OrcamentosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrcamentosController>(
      () => OrcamentosController(),
    );
  }
}
