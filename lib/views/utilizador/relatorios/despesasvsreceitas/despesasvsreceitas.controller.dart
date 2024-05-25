import 'package:get/get.dart';

import '../../../../models/utilizador/investimento.dart';
import '../../../../models/utilizador/saldo.dart';
import '../../../../repository/saldo.repository.dart';
import '../../../../services/storage_service.dart';

class DespesasVsReceitasController extends GetxController {
  final SaldoRepository _repoSaldo = SaldoRepository();
  final StorageService _storage = StorageService();
  RxBool isLoading = RxBool(true);
  RxString storedUserId = "".obs;
  final RxList<Investimento> investimentos = <Investimento>[].obs;
  final RxList<Saldo> saldos = <Saldo>[].obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxInt selectedMonth = DateTime.now().month.obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await carregarSaldos();
  }

  Future<void> carregarSaldos() async {
    if (storedUserId.value != "") {
      final result = await _repoSaldo.carregarSaldos(storedUserId.value);
      result.match(
        (l) => saldos.value = [],
        (r) => saldos.value = r,
      );
    }
    isLoading(false);
  }

  void filtrarPorAnoMes(int ano, int mes) {
    selectedYear.value = ano;
    selectedMonth.value = mes;
  }
}
