import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/button.utils.dart';
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
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Investimentos',
                          style: Theme.of(context).textTheme.titleLarge!),
                    ),
                    const SizedBox(height: 10),
                    if (controller.investimentos.isEmpty)
                      const Center(
                        child: Text(
                          "Nenhum investimento registado.",
                        ),
                      )
                    else
                      ...controller.investimentos.map((investimento) {
                        final valorFinal = controller
                                .valorFinalInvestimentos[investimento.id] ??
                            investimento.valor;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: (valorFinal - investimento.valor >= 0) ? const Icon(Icons.trending_up,
                                color: Colors.green) : const Icon(Icons.trending_down,
                                color: Colors.red),
                            title: Text(
                              investimento.tipo,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              onPressed: () => controller.removerInvestimento(
                                  investimento.id, valorFinal),
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonUtils.getElevatedButtons(context,
                          styleElevatedButton: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          textElevatedButton: "Adicionar Investimento",
                          functionElevatedButton: () =>
                              controller.modalAdicionarInvestimento(context),
                          elevatedButtonIcon: Icons.add),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
