import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/header/header.dart';
import '../../../widgets/menu/side_menu.page.dart';
import 'dados_utilizador.controller.dart';

class DadosUtilizadorPage extends GetView<DadosUtilizadorController> {
  const DadosUtilizadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPublic(),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final utilizador = controller.utilizador.value!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text('Dados Utilizador',
                      style: Theme.of(context).textTheme.titleLarge!),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: utilizador.nomeProprio,
                            decoration: const InputDecoration(
                              labelText: 'Nome Próprio',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) => controller.nomeProprio(val),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: utilizador.username,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) => controller.username(val),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: utilizador.email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: DateFormat('dd/MM/yyyy - HH:mm:ss')
                                .format(utilizador.ultimoAcesso!),
                            decoration: const InputDecoration(
                              labelText: 'Último Acesso',
                              border: OutlineInputBorder(),
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.atualizarDados,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text('Atualizar Dados'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => controller.mostrarPopUpEmailPass(context),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Atualizar Dados Sensíveis',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
