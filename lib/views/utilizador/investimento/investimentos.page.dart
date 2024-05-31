import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/header/header.dart';
import '../../../widgets/menu/side_menu.page.dart';
import 'investimentos.controller.dart';

class InvestimentosPage extends GetView<InvestimentosController> {
  const InvestimentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBarPublic(),
            drawer: const SideMenu(),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      Text('Investimentos',
                          style: Theme.of(context).textTheme.titleLarge!),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Obx(() {
                          if (controller.investimentos.isEmpty) {
                            return const Center(
                              child: Text(
                                "Nenhum investimento registado.",
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: controller.investimentos.length,
                              itemBuilder: (context, index) {
                                final investimento =
                                    controller.investimentos[index];
                                final valorFinal =
                                    controller.valorFinalInvestimentos[
                                            investimento.id] ??
                                        investimento.valor;
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.trending_up,
                                        color: Colors.green),
                                    title: Text(
                                      investimento.tipo,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Valor: ${investimento.valor.toStringAsFixed(2)} €",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "Valor Atual: ${valorFinal.toStringAsFixed(2)} €",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "Descrição: ${investimento.descricao}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.stop_circle_outlined,
                                          color: Colors.red),
                                      onPressed: () =>
                                          controller.removerInvestimento(
                                              investimento.id, valorFinal),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.modalAdicionarInvestimento(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text("Adicionar"),
                        ),
                      ),
                    ],
                  );
                }
              }),
            )));
  }
}
