import 'package:get/get.dart';

import 'dados_utilizador.controller.dart';

class DadosUtilizadorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DadosUtilizadorController>(
      () => DadosUtilizadorController(),
    );
  }
}
