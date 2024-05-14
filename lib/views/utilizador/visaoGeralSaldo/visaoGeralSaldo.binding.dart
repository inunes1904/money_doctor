import 'package:get/get.dart';
import 'package:moneydoctor/views/utilizador/visaoGeralSaldo/visaoGeralSaldo.controller.dart';

class VisaoGeralSaldoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisaoGeralSaldoController>(
      () => VisaoGeralSaldoController(),
    );
  }
}
