import 'package:get/get.dart';
import 'despesasvsreceitas.controller.dart';

class DespesasVsReceitasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DespesasVsReceitasController>(
      () => DespesasVsReceitasController(),
    );
  }
}
