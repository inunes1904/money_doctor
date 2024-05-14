import 'package:flutter/material.dart';
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
}
