import 'package:get/get.dart';
import 'despesasmensais.controller.dart';

class DespesasMensaisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DespesasMensaisController>(
      () => DespesasMensaisController(),
    );
  }
}
