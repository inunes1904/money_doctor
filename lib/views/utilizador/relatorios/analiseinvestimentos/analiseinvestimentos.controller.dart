import 'package:get/get.dart';
import '../../../../models/utilizador/investimento.dart';
import '../../../../models/utilizador/investimento_historico.dart';
import '../../../../repository/investimento.repository.dart';
import '../../../../services/storage_service.dart';

class AnaliseInvestimentosController extends GetxController {
  final InvestimentoRepository _repoInvest = InvestimentoRepository();
  final StorageService _storage = StorageService();
  RxBool isLoading = RxBool(true);
  RxString storedUserId = "".obs;
  final RxList<Investimento> investimentos = <Investimento>[].obs;
  final RxMap<String, HistoricoInvestimento> historicoInvestimentos =
      <String, HistoricoInvestimento>{}.obs;
  RxList<Investimento> investimentosFiltrados =
      <Investimento>[].obs;
  RxString filtroAtual = 'Todos'.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxInt selectedMonth = DateTime.now().month.obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await listarInvestimentos();
  }

  Future<void> listarInvestimentos() async {
    if (storedUserId.value != "") {
      final result = await _repoInvest.listarInvestimentos(storedUserId.value);
      result.match(
        (l) => investimentos.value = [],
        (r) async {
          investimentos.value = r;
          await carregarHistoricoInvestimentos();
          filtrarInvestimentos(filtroAtual.value);
        },
      );
    }
  }

  Future<void> carregarHistoricoInvestimentos() async {
    for (var investimento in investimentos) {
      final historicoResponse =
          await _repoInvest.obterHistoricoInvestimento(investimento.id);
      historicoResponse.match(
        (l) => null,
        (r) => historicoInvestimentos[investimento.id] = r,
      );
    }
  }

  void filtrarPorAnoMes(int ano, int mes) {
    selectedYear.value = ano;
    selectedMonth.value = mes;
    filtrarInvestimentos(filtroAtual.value);
  }

  void filtrarInvestimentos(String filtro) {
    filtroAtual.value = filtro;
    List<Investimento> filtrados = [];
    if (filtro == 'Abertos') {
      filtrados = investimentos.where((investimento) {
        final historico = historicoInvestimentos[investimento.id];
        return historico?.dataRetirada == null;
      }).toList();
    } else if (filtro == 'Encerrados') {
      filtrados = investimentos.where((investimento) {
        final historico = historicoInvestimentos[investimento.id];
        return historico?.dataRetirada != null;
      }).toList();
    } else {
      filtrados = investimentos;
    }
    investimentosFiltrados.value = filtrados
        .where((investimento) =>
            investimento.dataInvestimento!.year == selectedYear.value &&
            investimento.dataInvestimento!.month == selectedMonth.value)
        .toList();
    isLoading(false);
  }
}
