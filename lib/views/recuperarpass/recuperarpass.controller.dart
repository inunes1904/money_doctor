import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../../repository/authentication.repository.dart';
import '../../routes/app_routes.dart';
import '../../styles/global.colors.dart';

class RecuperarPassController extends GetxController {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final dialogKey = GlobalKey<FormState>();
  RxBool isLoading = RxBool(false);
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  //faz a submissao dos dados ao carregar no botao enviar
  //Valida os dados inseridos
  submit(context, {required GlobalKey<FormState> key}) {
    final isValid = key.currentState!.validate();
    if (!isValid) {
      return;
    }
    // onSaved que está em input.utils.dart guarda o value (.text) do controller
    key.currentState!.save();

    if (key == formKey) {
      // faz chamada à api para validar os dados de recuperarPassword
      recuperarPassword(context);
    } else if (key == dialogKey) {
      // faz chamada à api para recuperar password
    }
  }

  Future<void> recuperarPassword(context) async {
    //coloca a flag para indicar que está no processo de recuperação de password
    isLoading.value = true;
    // processo de recuperarPassword

// faz chamada ao authentication repository
    var res = await _authenticationRepository.recuperarPassword(
        email: emailController.text);
    res.fold((l) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Algo está errado',
        text:
            'Ocorreu um erro ao solicitar nova password. Confirme se o e-mail e password estão correctos.',
        confirmBtnText: 'Ok',
        confirmBtnColor: GlobalColors.dangerColor,
      );
    }, (r) {
      if (res == right(true)) {
        QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Verifique o seu e-mail',
        text:
            'Irá receber um e-mail para reconfigurar a password.',
        confirmBtnText: 'Ok',
        confirmBtnColor: GlobalColors.successColor,
      );
        // Redirecciona para a View Login
        Get.offNamed(AppRoutes.login);
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Algo está errado',
          text:
              'Ocorreu um erro ao solicitar nova password. Confirme se o e-mail e password estão correctos.',
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.dangerColor,
        );
      }
    });
    // .processo de recuperarPassword
    isLoading.value = false;
  }
}
