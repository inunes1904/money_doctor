import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import '../../../models/utilizador/orcamento_item.dart';
import '../../../repository/orcamento.repository.dart';
import '../../../models/utilizador/orcamento.dart';
import '../../../services/storage_service.dart';
import 'package:uuid/uuid.dart';

class OrcamentosController extends GetxController {
  final Uuid uuid = const Uuid();
  final OrcamentoRepository _repo = OrcamentoRepository();
  final StorageService _storage = StorageService();
  final RxList<Orcamento> orcamentos = <Orcamento>[].obs;
  RxBool isLoading = RxBool(true);
  RxString storedUserId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await carregarOrcamentos();
  }

  Future<void> carregarOrcamentos() async {
    if (storedUserId.value != "") {
      final result = await _repo.carregarOrcamentos(storedUserId.value);
      result.match(
        (l) => orcamentos.value = [],
        (r) => orcamentos.value = r,
      );
    }
    isLoading(false);
  }

  void adicionarOrcamento(Orcamento orcamento) async {
    final result = await _repo.adicionarOrcamento(orcamento);
    result.match(
      (l) => QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Adicionar',
        text: l,
        confirmBtnText: 'Ok',
        confirmBtnColor: Colors.red,
      ),
      (r) {
        if (r) {
          orcamentos.add(orcamento);
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: 'Sucesso',
            text: 'Orçamento adicionado com sucesso!',
            confirmBtnText: 'Ok',
            confirmBtnColor: Colors.green,
          );
        }
      },
    );
  }

  void removerOrcamento(String orcamentoId) async {
    final result = await _repo.removerOrcamento(orcamentoId);
    result.match(
      (l) => QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Remover',
        text: l,
        confirmBtnText: 'Ok',
        confirmBtnColor: Colors.red,
      ),
      (r) {
        if (r) {
          orcamentos.removeWhere((x) => x.id == orcamentoId);
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: 'Sucesso',
            text: 'Orçamento removido com sucesso!',
            confirmBtnText: 'Ok',
            confirmBtnColor: Colors.green,
          );
        }
      },
    );
  }

  void adicionarItem(String orcamentoId, ItemOrcamento item) async {
    final result = await _repo.adicionarItem(item);
    result.match(
      (l) => QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Adicionar Item',
        text: l,
        confirmBtnText: 'Ok',
        confirmBtnColor: Colors.red,
      ),
      (r) {
        if (r) {
          final orcamento = orcamentos.firstWhere((o) => o.id == orcamentoId);
          orcamento.itens.add(item);
          orcamentos.refresh();
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: 'Sucesso',
            text: 'Item adicionado com sucesso!',
            confirmBtnText: 'Ok',
            confirmBtnColor: Colors.green,
          );
        }
      },
    );
  }

  void removerItem(String orcamentoId, String itemId) async {
    final result = await _repo.removerItem(itemId);
    result.match(
      (l) => QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Remover Item',
        text: l,
        confirmBtnText: 'Ok',
        confirmBtnColor: Colors.red,
      ),
      (r) {
        if (r) {
          final orcamento = orcamentos.firstWhere((o) => o.id == orcamentoId);
          orcamento.itens.removeWhere((item) => item.id == itemId);
          orcamentos.refresh();
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: 'Sucesso',
            text: 'Item removido com sucesso!',
            confirmBtnText: 'Ok',
            confirmBtnColor: Colors.green,
          );
        }
      },
    );
  }

  // Formulário para adicionar Orçamento
  void modalAdicionarOrcamento(BuildContext context) {
    final TextEditingController categoriaController = TextEditingController();
    final TextEditingController valorController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Orçamento'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: categoriaController,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor Planeado',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Adicionar'),
                onPressed: () {
                  final orcamento = Orcamento(
                    id: uuid.v4(), // ID único para o orçamento
                    utilizadorId: storedUserId.value,
                    categoria: categoriaController.text,
                    valorPlaneado: double.tryParse(valorController.text) ?? 0,
                    dataOrcamento: DateTime.now(),
                    descricao: descricaoController.text,
                    itens: [], // Inicialmente, sem itens
                  );
                  adicionarOrcamento(orcamento);
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
                    borderRadius: BorderRadius.circular(8),
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

  // Formulário para adicionar Item
  void modalAdicionarItem(BuildContext context, String orcamentoId) {
    final TextEditingController descricaoController = TextEditingController();
    final TextEditingController valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Item'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
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
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final item = ItemOrcamento(
                    id: uuid.v4(), // ID único para o item
                    orcamentoId: orcamentoId,
                    descricao: descricaoController.text,
                    valor: double.tryParse(valorController.text) ?? 0,
                  );
                  adicionarItem(orcamentoId, item);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text("Adicionar"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Cancelar"),
              ),
            ),
          ],
        );
      },
    );
  }
}
