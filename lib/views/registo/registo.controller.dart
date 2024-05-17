import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../repository/authentication.repository.dart';
import '../../styles/global.colors.dart';

class RegistoController extends GetxController {
  RxBool isAuthenticating = RxBool(false);
  final registoKey = GlobalKey<FormState>();
  TextEditingController nomeProprio = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController passwordUtilizador = TextEditingController();
  TextEditingController repetePasswordUtilizador = TextEditingController();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  // Faz a submissao dos dados ao carregar no botao Registar
  submit(context, {required GlobalKey<FormState> key}) async {
    // Valida os dados inseridos
    final isValid = key.currentState!.validate();

    // onSaved que está em input.utils.dart guarda o value (.text) de cada controller
    key.currentState!.save();

        // Se passwords não forem iguais, não valida restante formulário
    if (passwordUtilizador.text != repetePasswordUtilizador.text) {
      // as passwords não coincidem --> Criar mensagem de erro
      return;
    }

    // Se isValid é false, significa que algum input não foi validado
    if (!isValid) {
      return;
    }

    // faz chamada à BD para validar os dados de novo registo
    await novoRegisto(context);
  }

  // Se necessário validar dados usar o Validate e para guardar o Save
  Future<void> novoRegisto(context) async {
    //coloca a flag para indicar que está no processo de criação de novo registo
    isAuthenticating.value = true;

    // faz chamada ao authentication repository
    var res = await _authenticationRepository.registarUtilizador(
        nomeProprio: nomeProprio.text,
        email: email.text,
        username: username.text,
        password: passwordUtilizador.text);
    res.fold((l) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Algo está errado',
        text:
            'O registo não foi bem sucedido. Por favor tente mais tarde. Caso o problema persista, contacte a nossa equipa.',
        confirmBtnText: 'Ok',
        confirmBtnColor: GlobalColors.dangerColor,
      );
    }, (r) {
      if (res == right(true)) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Registo bem sucedido',
          text: 'Irá receber um e-mail em breve.',
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.successColor,
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Algo está errado',
          text:
              'O registo não foi bem sucedido. Por favor tente mais tarde. Caso o problema persista, contacte a nossa equipa.',
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.dangerColor,
        );
      }
    });

    isAuthenticating.value = false;
  }

  void unfocusInput(context) async {
    UnfocusDisposition disposition = UnfocusDisposition.scope;
    primaryFocus!.unfocus(disposition: disposition);
  }
}
