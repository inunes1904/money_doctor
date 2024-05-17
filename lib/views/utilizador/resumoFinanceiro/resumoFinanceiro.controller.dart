import 'package:get/get.dart';
import '../../../repository/saldo.repository.dart';
import '../../../repository/investimento.repository.dart';
import '../../../models/utilizador/saldo.dart';
import '../../../models/utilizador/investimento.dart';

import '../../../services/storage_service.dart';

class ResumoFinanceiroController extends GetxController {
  final SaldoRepository saldoRepository = SaldoRepository();
  final StorageService _storage = StorageService();
  final InvestimentoRepository investimentoRepository =
      InvestimentoRepository();
  final RxList<Saldo> saldos = <Saldo>[].obs;
  final RxList<Investimento> investimentos = <Investimento>[].obs;
  final RxString error = ''.obs;
  RxBool isLoading = RxBool(true);
  RxString storedUserId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await carregarDadosFinanceiros();
  }

  Future<void> carregarDadosFinanceiros() async {
    if (storedUserId.value != "") {
      saldoRepository.carregarSaldos(storedUserId.value).then((result) {
        result.fold(
          (l) {
            error.value = 'Nenhum saldo encontrado';
          },
          (r) {
            if (r.isNotEmpty) {
              saldos.value = r.cast<Saldo>();
            } else {
              error.value = 'Nenhum saldo encontrado';
            }
          },
        );
        isLoading(false);
      });

      investimentoRepository
          .carregarInvestimentos(storedUserId.value)
          .then((result) {
        result.fold(
          (l) {
            error.value = 'Nenhum investimento encontrado';
          },
          (r) {
            if (r.isNotEmpty) {
              investimentos.value = r.cast<Investimento>();
            } else {
              error.value = 'Nenhum investimento encontrado';
            }
          },
        );
      });
    }
  }
}
