import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import '../../../models/storage_item.dart';
import '../../../models/utilizador/utilizador.dart';
import '../../../repository/utilizador.repository.dart';
import '../../../services/storage_service.dart';
import '../../../styles/global.colors.dart';

class DadosUtilizadorController extends GetxController {
  final Rx<Utilizador?> utilizador = Rx<Utilizador?>(null);
  final StorageService _storage = StorageService();
  final UtilizadorRepository utilizadorRepo = UtilizadorRepository();
  RxString nomeProprio = ''.obs;
  RxString username = ''.obs;
  RxBool isLoading = RxBool(true);
  RxBool hasError = RxBool(false);
  RxString storedUserId = "".obs;
  TextEditingController alterarEmailController = TextEditingController();
  TextEditingController alterarPasswordController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    isLoading(true);
    hasError(false);
    update();

    if (storedUserId.value != "") {
      Utilizador? dados =
          await utilizadorRepo.getDadosUtilizador(storedUserId.value);
      if (dados != null) {
        utilizador(dados);
        nomeProprio(dados.nomeProprio);
        username(dados.username);
        alterarEmailController.text = dados.email; // Pre-fill email
      } else {
        hasError(true);
      }
      isLoading(false);
      update();
    }
  }

  Future<void> atualizarDados() async {
    if (utilizador.value != null) {
      isLoading(true);
      update();

      Utilizador updatedUser = Utilizador(
        id: utilizador.value!.id,
        nomeProprio: nomeProprio.value,
        email: utilizador.value!.email,
        username: username.value,
        ultimoAcesso: utilizador.value!.ultimoAcesso,
      );

      var result = await utilizadorRepo.alteraUtilizador(updatedUser);
      result.match(
        (l) => QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Erro ao atualizar dados!',
          text: l,
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.dangerColor,
        ),
        (r) async {
          if (r) {
            QuickAlert.show(
              context: Get.context!,
              type: QuickAlertType.success,
              title: 'Sucesso',
              text: 'Dados alterados com sucesso!',
              confirmBtnText: 'Ok',
              confirmBtnColor: GlobalColors.successColor,
            );
          }
        },
      );
      // Atualizar dados localmente e mostrar mensagem de sucesso/erro
      await _storage
          .writeSecureData(StorageItem("nomeProprio", nomeProprio.value));
      await _storage.writeSecureData(StorageItem("username", username.value));
      await carregarDadosUsuario(); // Recarregar dados do usuário após a atualização

      isLoading(false);
      update();
    }
  }

  void mostrarPopUpEmailPass(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Atualizar Dados Sensíveis',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: alterarEmailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: alterarPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  atualizarDadosSensiveis(alterarEmailController.text,
                      alterarPasswordController.text);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Alterar dados'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> atualizarDadosSensiveis(
      String emailAlterado, String passwordAlterada) async {
    if (utilizador.value != null) {
      isLoading(true);
      update();

      var result = await utilizadorRepo.alterarEmailPassword(
          email: emailAlterado, password: passwordAlterada);

      result.match(
        (l) => QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Erro ao atualizar dados!',
          text: l,
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.dangerColor,
        ),
        (r) async {
          if (r) {
            QuickAlert.show(
              context: Get.context!,
              type: QuickAlertType.success,
              title: 'Sucesso',
              text: 'Dados alterados com sucesso!',
              confirmBtnText: 'Ok',
              confirmBtnColor: GlobalColors.successColor,
            );
          }
        },
      );
      isLoading(false);
      update();
    }
  }
}
