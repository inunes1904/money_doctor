import 'package:get/get.dart';
import '../../../repository/saldo.repository.dart';
import '../../../repository/investimento.repository.dart';
import '../../../models/utilizador/saldo.dart';
import '../../../models/utilizador/investimento.dart';

import '../../../services/storage_service.dart';
import '../../../repository/evento.repository.dart';
import '../../../models/utilizador/evento.dart';

class ResumoFinanceiroController extends GetxController {
  final SaldoRepository saldoRepository = SaldoRepository();
  final StorageService _storage = StorageService();
  final InvestimentoRepository investimentoRepository =
      InvestimentoRepository();
  final EventoRepository eventoRepository = EventoRepository();
  final RxList<Saldo> saldos = <Saldo>[].obs;
  final RxList<Investimento> investimentos = <Investimento>[].obs;
  final RxList<Evento> eventos = <Evento>[].obs;
  final RxString mensagemSaldo = ''.obs;
  final RxString mensagemInvestimentos = ''.obs;
  final RxString mensagemDespesasPartilhadas = ''.obs;
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
            mensagemSaldo.value = 'Nenhum saldo encontrado';
          },
          (r) {
            if (r.isNotEmpty) {
              saldos.value = r.cast<Saldo>();
            } else {
              mensagemSaldo.value = 'Nenhum saldo encontrado';
            }
          },
        );
      });

      investimentoRepository
          .carregarInvestimentos(storedUserId.value)
          .then((result) {
        result.fold(
          (l) {
            mensagemInvestimentos.value = 'Nenhum investimento encontrado';
          },
          (r) {
            if (r.isNotEmpty) {
              investimentos.value = r.cast<Investimento>();
            } else {
              mensagemInvestimentos.value = 'Nenhum investimento encontrado';
            }
          },
        );
      });

      eventoRepository.carregarEventos(storedUserId.value).then((result) {
        result.fold(
          (l) {
            mensagemDespesasPartilhadas.value = 'Nenhuma despesa partilhada encontrada';
          },
          (r) {
            if (r.isNotEmpty) {
              eventos.value =
                  r.where((evento) => evento.status).cast<Evento>().toList();
            } else {
              mensagemDespesasPartilhadas.value = 'Nenhuma despesa partilhada encontrada';
            }
          },
        );
      });
    }
    isLoading(false);
  }
}
