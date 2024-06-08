import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moneydoctor/styles/global.colors.dart';
import '../../../repository/saldo.repository.dart';
import '../../../models/utilizador/saldo.dart';
import 'package:quickalert/quickalert.dart';
import '../../../services/storage_service.dart';

class VisaoGeralSaldoController extends GetxController {
  final StorageService _storage = StorageService();
  final RxList<Saldo> saldos = <Saldo>[].obs;
  final SaldoRepository _repo = SaldoRepository();
  TextEditingController valorController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  RxBool isLoading = RxBool(true);
  RxString storedUserId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await carregarSaldos();
  }

  Future<void> carregarSaldos() async {
    if (storedUserId.value != "") {
      final result = await _repo.carregarSaldos(storedUserId.value);
      result.match(
        (l) => saldos.value = [],
        (r) => saldos.value = r,
      );
    }
    isLoading(false);
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
        (r) => {if (r) carregarSaldos()},
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
        (r) => {if (r) carregarSaldos()},
      );
    }
  }

  Future<void> modalAdicionarRemover(context, String action) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action valor'),
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
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (valorController.text.isNotEmpty &&
                              descricaoController.text.isNotEmpty) {
                            final valor =
                                double.tryParse(valorController.text) ?? 0.0;
                            if (action == "Adicionar") {
                              adicionarValor(
                                double.parse(valor.toStringAsFixed(2)),
                                descricaoController.text,
                              );
                            } else {
                              retirarValor(
                                double.parse(valor.toStringAsFixed(2)),
                                descricaoController.text,
                              );
                            }
                            valorController.clear();
                            descricaoController.clear();
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              action == "Adicionar" ? Colors.green : Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("$action valor"),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          valorController.clear();
                          descricaoController.clear();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Cancelar"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
