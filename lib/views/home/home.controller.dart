import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import '../../models/categorias/categorias.dart';
import '../../repository/saldo.repository.dart';
import '../../services/storage_service.dart';
import '../../styles/global.colors.dart';
import 'categorias_data.dart';

class HomeController extends GetxController {
  RxBool isLoading = RxBool(true);
  RxBool hasError = RxBool(false);
  final List<Categorias> opcoesMoneyApp = categoriasList;
  final StorageService _storage = StorageService();
  RxString storedUsername = "Utilizador".obs;
  RxString storedUserId = "".obs;
  final SaldoRepository _repo = SaldoRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading = false.obs;
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    storedUsername.value =
        await _storage.readSecureData("username") ?? "Utilizador";
  }

  void modalAlterarSaldo(context, accaoSaldo) {
    final TextEditingController valorController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$accaoSaldo valor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10.0,
                ),
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
                onPressed: () {
                  final valor = double.tryParse(valorController.text) ?? 0;
                  final descricao = descricaoController.text;
                  accaoSaldo == "Adicionar"
                      ? adicionarValor(valor, descricao)
                      : retirarValor(valor, descricao);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  backgroundColor:
                      accaoSaldo == "Adicionar" ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text('$accaoSaldo valor'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
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

  void adicionarValor(double valor, String descricao) async {
    if (storedUserId.value != "") {
      final result = await _repo.atualizarSaldo(
          storedUserId.value, valor, true, descricao);
      result.match(
        (l) => QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Erro ao Adicionar',
          text: l,
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.dangerColor,
        ),
        (r) => QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          title: 'Receita adicionado',
          text: "O valor de $valor foi adicionado ao seu saldo.",
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.successColor,
        ),
      );
    }
  }

  void retirarValor(double valor, String descricao) async {
    if (storedUserId.value != "") {
      final result = await _repo.atualizarSaldo(
          storedUserId.value, valor, false, descricao);
      result.match(
        (l) => QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Erro ao Retirar',
          text: l,
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.dangerColor,
        ),
        (r) => QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          title: 'Despesa adicionada',
          text: "O valor de $valor foi retirado do seu saldo.",
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.successColor,
        ),
      );
    }
  }
}
