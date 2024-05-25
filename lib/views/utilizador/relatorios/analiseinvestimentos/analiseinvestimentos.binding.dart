import 'package:get/get.dart';
import 'analiseinvestimentos.controller.dart';

class AnaliseInvestimentosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnaliseInvestimentosController>(
      () => AnaliseInvestimentosController(),
    );
  }
}
