import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../../repository/authentication.repository.dart';
import '../../routes/app_routes.dart';
import '../../styles/global.colors.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController recuperaEmailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final dialogKey = GlobalKey<FormState>();
  RxBool isAuthenticating = RxBool(false);
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    _authenticationRepository.logout();
  }

  //faz a submissao dos dados ao carregar no botao entrar
  //Valida os dados inseridos
  submit(context, {required GlobalKey<FormState> key}) {
    final isValid = key.currentState!.validate();
    if (!isValid) {
      return;
    }
    // onSaved que está em input.utils.dart guarda o value (.text) do controller
    key.currentState!.save();

    if (key == formKey) {
      // faz chamada à api para validar os dados de login
      login(context);
    } else if (key == dialogKey) {
      // faz chamada à api para recuperar password
    }
  }

  Future<void> login(context) async {
    //coloca a flag para indicar que está no processo de verificação do login
    isAuthenticating.value = true;
    // processo de login

// faz chamada ao authentication repository
    var res = await _authenticationRepository.login(
        email: emailController.text, password: passwordController.text);
    res.fold((l) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Algo está errado',
        text:
            'Ocorreu um erro de validação. Confirme se o e-mail e password estão correctos.',
        confirmBtnText: 'Ok',
        confirmBtnColor: GlobalColors.dangerColor,
      );
    }, (r) {
      if (res == right(true)) {
        // Guarda dados localmente

        // Redirecciona para a View Home
        Get.offNamed(AppRoutes.home);
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Algo está errado',
          text:
              'Ocorreu um erro de validação. Confirme se o e-mail e password estão correctos.',
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.dangerColor,
        );
      }
    });
    // .processo de login
    isAuthenticating.value = false;
  }
}
