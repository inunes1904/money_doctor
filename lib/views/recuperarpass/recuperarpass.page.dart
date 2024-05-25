import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneydoctor/styles/global.colors.dart';
import 'package:moneydoctor/utils/button.utils.dart';
import 'package:moneydoctor/utils/input.utils.dart';
import '../../widgets/header/header.dart';
import 'recuperarpass.controller.dart';

class RecuperarPassPage extends GetView<RecuperarPassController> {
  const RecuperarPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPublic(),
      // drawer: const SideMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
        child: Column(
          children: [
            Text(
              'Recuperar Password',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                color: GlobalColors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              constraints: const BoxConstraints(maxWidth: 750),
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 20.0, right: 10.0, left: 10.0),
              margin: const EdgeInsets.only(
                  top: 10.0, bottom: 50.0, right: 8.0, left: 8.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Image(
                      image: AssetImage('assets/images/ICON.png'),
                    ),
                    const SizedBox(height: 20),
                    InputUtils.getInputFields(
                      inputFieldController: controller.emailController,
                      inputFieldName: "E-mail",
                      inputFieldTextType: TextInputType.name,
                      inputFieldIcon: Icons.person,
                      inputFieldRequired: true,
                    ),
                    Obx(() {
                      // Se está em processamento, botão fica inactivo, para evitar mais que uma chamada
                      if (controller.isLoading.value) {
                        return Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: const CircularProgressIndicator(
                                // color: GlobalColors.lightPearl,
                                ));
                      } else {
                        // Caso contrário, mostra botão
                        return Column(
                          children: [
                            const SizedBox(height: 10.0),
                            ButtonUtils.getElevatedButtons(context,
                                styleElevatedButton: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                ),
                                textElevatedButton: "Enviar",
                                functionElevatedButton: () => controller
                                    .submit(context, key: controller.formKey),
                                elevatedButtonIcon: Icons.send),
                            const SizedBox(height: 6.0),
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
