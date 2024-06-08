import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:moneydoctor/styles/global.colors.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import '../../../models/utilizador/investimento_historico.dart';
import '../../../repository/investimento.repository.dart';
import '../../../models/utilizador/investimento.dart';
import '../../../services/storage_service.dart';

class InvestimentosController extends GetxController {
  final Uuid uuid = const Uuid();
  final InvestimentoRepository _repo = InvestimentoRepository();
  final StorageService _storage = StorageService();
  final RxList<Investimento> investimentos = <Investimento>[].obs;
  final RxMap<String, double> valorFinalInvestimentos = <String, double>{}.obs;
  RxBool isLoading = RxBool(true);
  RxString storedUserId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await carregarInvestimentos();
  }

  Future<void> carregarInvestimentos() async {
    isLoading.value = true;
    if (storedUserId.value != "") {
      final result = await _repo.carregarInvestimentos(storedUserId.value);
      result.match(
        (l) {
          investimentos.value = [];
          isLoading.value = false;
        },
        (r) async {
          investimentos.value = r;
          await sortearValoresFinais();
          isLoading.value = false;
        },
      );
    } else {
      isLoading.value = false;
    }
  }

  Future<void> sortearValoresFinais() async {
    final random = Random();
    for (var investimento in investimentos) {
      final valorFinal = investimento.valor *
          (0.8 +
              random.nextDouble() *
                  0.4); // Valor final entre 80% e 120% do valor inicial
      valorFinalInvestimentos[investimento.id] = valorFinal;
      await atualizarValorFinalInvestimento(investimento.id, valorFinal);
    }
  }

  Future<void> adicionarInvestimento(Investimento investimento) async {
    final result = await _repo.adicionarInvestimento(investimento);
    result.match(
      (l) => QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Adicionar',
        text: l,
        confirmBtnText: 'Ok',
        confirmBtnColor: GlobalColors.dangerColor,
      ),
      (r) async {
        if (r) {
          investimentos.add(investimento);
          final historico = HistoricoInvestimento(
            id: uuid.v4(),
            investimentoId: investimento.id,
            usuarioId: investimento.utilizadorId,
            tipo: investimento.tipo,
            valorInicial: investimento.valor,
            dataInvestimento: DateTime.now(),
            descricao: investimento.descricao,
          );
          await adicionarInvestimentoHistorico(historico);
          await sortearValorFinal(investimento);
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: 'Sucesso',
            text: 'Investimento adicionado com sucesso!',
            confirmBtnText: 'Ok',
            confirmBtnColor: GlobalColors.successColor,
          );
        }
      },
    );
  }

  Future<void> sortearValorFinal(Investimento investimento) async {
    final random = Random();
    final valorFinal = investimento.valor *
        (0.8 +
            random.nextDouble() *
                0.4); // Valor final entre 80% e 120% do valor inicial
    valorFinalInvestimentos[investimento.id] = valorFinal;
    await atualizarValorFinalInvestimento(investimento.id, valorFinal);
  }

  Future<void> removerInvestimento(
      String investimentoId, double valorFinal) async {
    final result = await _repo.removerInvestimento(investimentoId, valorFinal);
    result.match(
      (l) => QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Remover',
        text: l,
        confirmBtnText: 'Ok',
        confirmBtnColor: GlobalColors.dangerColor,
      ),
      (r) async {
        if (r) {
          final investimento =
              investimentos.firstWhere((x) => x.id == investimentoId);
          await fecharInvestimentoHistorico(investimento);
          investimentos.removeWhere((x) => x.id == investimentoId);
          valorFinalInvestimentos.remove(investimentoId);
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: 'Sucesso',
            text: 'Investimento liquidado com sucesso!',
            confirmBtnText: 'Ok',
            confirmBtnColor: GlobalColors.successColor,
          );
        }
      },
    );
  }

  Future<void> adicionarInvestimentoHistorico(
      HistoricoInvestimento historico) async {
    await _repo.adicionarInvestimentoHistorico(historico);
  }

  Future<void> fecharInvestimentoHistorico(Investimento investimento) async {
    final valorFinal =
        valorFinalInvestimentos[investimento.id] ?? investimento.valor;
    await _repo.fecharInvestimentoHistorico(
      investimentoId: investimento.id,
      valorFinal: valorFinal,
      dataRetirada: DateTime.now(),
    );
  }

  Future<void> atualizarValorFinalInvestimento(
      String investimentoId, double valorFinal) async {
    await _repo.atualizarValorFinalInvestimento(
      id: investimentoId,
      valorFinal: valorFinal,
    );
  }

  // Formulário para adicionar investimento
  void modalAdicionarInvestimento(BuildContext context) {
    final TextEditingController tipoController = TextEditingController();
    final TextEditingController valorController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Investimento',
              style: TextStyle(fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: tipoController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Adicionar'),
                onPressed: () {
                  final investimento = Investimento(
                    id: uuid.v4(), // ID único para o investimento
                    utilizadorId: storedUserId.value,
                    tipo: tipoController.text,
                    valor: double.tryParse(valorController.text) ?? 0,
                    dataInvestimento: DateTime.now(),
                    descricao: descricaoController.text,
                  );
                  adicionarInvestimento(investimento);
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
