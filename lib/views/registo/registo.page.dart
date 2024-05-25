import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/button.utils.dart';
import '../../utils/input.utils.dart';
import '../../widgets/header/header.dart';
import 'registo.controller.dart';

class RegistoPage extends GetView<RegistoController> {
  const RegistoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPublic(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
        child: Column(
          children: [
            Text(
              'Novo Utilizador',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!,
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: Form(
                key: controller.registoKey,
                child: Column(children: [
                  Card(
                    margin: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 20.0, right: 10.0, left: 10.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          InputUtils.getInputFields(
                            inputFieldController: controller.nomeProprio,
                            inputFieldName: "Nome Próprio",
                            inputFieldTextType: TextInputType.name,
                            inputFieldRequired: true,
                            inputFieldLimitedNumber: 300,
                          ),
                          const SizedBox(height: 10),
                          InputUtils.getInputFields(
                            inputFieldController: controller.email,
                            inputFieldName: "Email",
                            inputFieldTextType: TextInputType.emailAddress,
                            inputFieldRequired: true,
                            inputFieldLimitedNumber: 200,
                          ),
                          const SizedBox(height: 10),
                          InputUtils.getInputFields(
                            inputFieldController: controller.username,
                            inputFieldName: "Username",
                            inputFieldTextType: TextInputType.name,
                            inputFieldRequired: true,
                            inputFieldLimitedNumber: 200,
                          ),
                          const SizedBox(height: 10),
                          InputUtils.getInputFields(
                            inputFieldController: controller.passwordUtilizador,
                            inputFieldName: "Password",
                            inputFieldTextType: TextInputType.visiblePassword,
                            hiddenInputText: true,
                            inputFieldRequired: true,
                            inputFieldLimitedNumber: 200,
                          ),
                          const SizedBox(height: 10),
                          InputUtils.getInputFields(
                            inputFieldController:
                                controller.repetePasswordUtilizador,
                            inputFieldName: "Repita a password",
                            inputFieldTextType: TextInputType.visiblePassword,
                            hiddenInputText: true,
                            inputFieldRequired: true,
                            inputFieldLimitedNumber: 20,
                          ),
                          const SizedBox(height: 20),
                          Obx(() {
                            if (controller.isAuthenticating.value) {
                              return const CircularProgressIndicator();
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2.0),
                                child: ButtonUtils.getElevatedButtons(
                                  context,
                                  styleElevatedButton: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green),
                                  ),
                                  textElevatedButton: "Registar",
                                  functionElevatedButton: () =>
                                      controller.submit(context,
                                          key: controller.registoKey),
                                  elevatedButtonIcon: Icons.app_registration,
                                ),
                              );
                            }
                          })
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
