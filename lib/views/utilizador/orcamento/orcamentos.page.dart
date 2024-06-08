import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../styles/global.colors.dart';
import '../../../utils/button.utils.dart';
import '../../../widgets/header/header.dart';
import '../../../widgets/menu/side_menu.page.dart';
import 'orcamentos.controller.dart';

class OrcamentosPage extends GetView<OrcamentosController> {
  const OrcamentosPage({super.key});

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
                      child: Text('Orçamentos',
                          style: Theme.of(context).textTheme.titleLarge!),
                    ),
                    const SizedBox(height: 10),
                    if (controller.orcamentos.isEmpty)
                      const Center(
                        child: Text("Nenhum orçamento registado.",),
                      )
                    else
                      ...controller.orcamentos.map((orcamento) {
                        final totalGasto = orcamento.itens
                            .fold(0.0, (sum, item) => sum + item.valor);
                        final saldoRestante =
                            orcamento.valorPlaneado - totalGasto;
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      orcamento.categoria,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox( width: 50, child: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => controller
                                          .removerOrcamento(orcamento.id),
                                    ),)
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Valor Planeado: ${orcamento.valorPlaneado.toStringAsFixed(2)} €",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Descrição: ${orcamento.descricao}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Itens:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ...orcamento.itens.map((item) {
                                      return Card(
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.descricao),
Text(
                                                "Custo ${item.valor.toStringAsFixed(2)} €",
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () => controller
                                                    .removerItem(
                                                        orcamento.id, item.id),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 10),
                                ButtonUtils.getElevatedButtons(context,
                            styleElevatedButton: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            textElevatedButton: "Adicionar Linha",
                            functionElevatedButton: () =>
                                controller.modalAdicionarItem(
                                          context, orcamento.id),
                            elevatedButtonIcon: Icons.add_shopping_cart),
                            const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    const Text(
                                      "Saldo Restante: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "${saldoRestante.toStringAsFixed(2)} €",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: saldoRestante >= 0
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                          textElevatedButton: "Adicionar Orçamento",
                          functionElevatedButton: () =>
                              controller.modalAdicionarOrcamento(context),
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
