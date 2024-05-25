import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneydoctor/routes/app_routes.dart';
import 'package:moneydoctor/styles/global.colors.dart';
import 'package:moneydoctor/utils/button.utils.dart';
import 'package:moneydoctor/utils/input.utils.dart';
import '../../widgets/header/header.dart';
import '../../widgets/menu/side_menu.page.dart';
import 'login.controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPublic(),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
              child: Column(
      children: [
        Text(
          'Login',
          style: Theme.of(context)
              .textTheme
              .titleLarge!,
        ),
        Container(
          decoration: const BoxDecoration(
            color: GlobalColors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          constraints: const BoxConstraints(maxWidth: 750),
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 20.0, right: 10.0, left: 10.0),
          margin: const EdgeInsets.only(
              top: 10.0, bottom: 150.0, right: 8.0, left: 8.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
      const Image(
          image: AssetImage('assets/images/ICON.png'),
        ),
        const SizedBox(height: 20.0),
        Text(
          'Bem-vindo à aplicação da Money Doctor',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      
                const SizedBox(height: 20),
                InputUtils.getInputFields(
                  inputFieldController: controller.emailController,
                  inputFieldName: "E-mail",
                  inputFieldTextType: TextInputType.name,
                  inputFieldIcon: Icons.person,
                  inputFieldRequired: true,
                ),
                const SizedBox(height: 20),
                InputUtils.getInputFields(
                  inputFieldController: controller.passwordController,
                  inputFieldName: "Password",
                  inputFieldTextType: TextInputType.visiblePassword,
                  inputFieldIcon: Icons.password,
                  hiddenInputText: true,
                  inputFieldRequired: true,
                ),
                Obx(() {
                  // Se está a tentar autenticar, botão fica inactivo, para evitar mais que uma chamada
                  if (controller.isAuthenticating.value) {
                    return Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: const CircularProgressIndicator(
                            // color: GlobalColors.lightPearl,
                            ));
                  } else {
                    // Caso contrário, mostra botão
                    return Column(
                      children: [
                        const SizedBox(height: 20.0),
                        ButtonUtils.getElevatedButtons(context,
                            styleElevatedButton: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.green),
                            ),
                            textElevatedButton: "Entrar",
                            functionElevatedButton: () => controller
                                .submit(context, key: controller.formKey),
                            elevatedButtonIcon: Icons.login),
                        const SizedBox(height: 30.0),
                        ButtonUtils.getTextButtons(
                          functionTextButton: () =>
                              Get.toNamed(AppRoutes.recuperarpass),
                          textButtonText: "Esqueceu a password?",
                          styleTextButton:
                              Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 2.0),
                        ButtonUtils.getTextButtons(
                          functionTextButton: () =>
                              Get.toNamed(AppRoutes.registo),
                          textButtonText:
                              "Ainda não está registado? Faça já o seu registo",
                          styleTextButton:
                              Theme.of(context).textTheme.headlineSmall,
                        )
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ],
              ),
            ),
    );
  }
}
