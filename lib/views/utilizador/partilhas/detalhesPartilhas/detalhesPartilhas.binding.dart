import 'package:get/get.dart';
import 'detalhesPartilhas.controller.dart';

class DetalhesPartilhasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetalhesPartilhasController>(
      () => DetalhesPartilhasController(),
    );
  }
}
