import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:moneydoctor/styles/global.colors.dart';
import 'package:uuid/uuid.dart';
import '../../../repository/investimento.repository.dart';
import '../../../models/utilizador/investimento.dart';
import '../../../services/storage_service.dart';

class InvestimentosController extends GetxController {
  final Uuid uuid = const Uuid();
  final InvestimentoRepository _repo = InvestimentoRepository();
  final StorageService _storage = StorageService();
  final RxList<Investimento> investimentos = <Investimento>[].obs;
  RxBool isLoading = RxBool(true);
  RxString storedUserId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await carregarInvestimentos();
  }

  Future<void> carregarInvestimentos() async {
    if (storedUserId.value != "") {
      final result = await _repo.carregarInvestimentos(storedUserId.value);
      result.match(
        (l) => investimentos.value = [],
        (r) => investimentos.value = r,
      );
    }
    isLoading(false);
  }

  void adicionarInvestimento(Investimento investimento) async {
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
      (r) {
        if (r) {
          investimentos.add(investimento);
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

  void removerInvestimento(String investimentoId) async {
    final result = await _repo.removerInvestimento(investimentoId);
    result.match(
      (l) => QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Remover',
        text: l,
        confirmBtnText: 'Ok',
        confirmBtnColor: GlobalColors.dangerColor,
      ),
      (r) {
        if (r) {
          investimentos.removeWhere((x) => x.id == investimentoId);
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: 'Sucesso',
            text: 'Investimento removido com sucesso!',
            confirmBtnText: 'Ok',
            confirmBtnColor: GlobalColors.successColor,
          );
        }
      },
    );
  }

  // Formulário para adicionar investimento
  void modalAdicionarInvestimento(BuildContext context) {
    final TextEditingController tipoController = TextEditingController();
    final TextEditingController valorController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Investimento'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: tipoController,
                  decoration: InputDecoration(labelText: 'Tipo'),
                ),
                TextField(
                  controller: valorController,
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
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
          ],
        );
      },
    );
  }
}
