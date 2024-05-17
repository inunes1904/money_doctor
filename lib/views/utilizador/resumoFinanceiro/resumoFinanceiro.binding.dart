import 'package:get/get.dart';
import 'resumoFinanceiro.controller.dart';

class ResumoFinanceiroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResumoFinanceiroController>(
      () => ResumoFinanceiroController(),
    );
  }
}
