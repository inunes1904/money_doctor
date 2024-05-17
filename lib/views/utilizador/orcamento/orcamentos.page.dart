import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../styles/global.colors.dart';
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
              return Column(
                children: [
                  Text(
                    'Orçamentos',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      if (controller.orcamentos.isEmpty) {
                        return const Center(
                          child: Text("Nenhum orçamento registado.",
                              style: TextStyle(fontSize: 18)),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: controller.orcamentos.length,
                          itemBuilder: (context, index) {
                            final orcamento = controller.orcamentos[index];
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
                                    Text(
                                      orcamento.categoria,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: orcamento.itens.length,
                                      itemBuilder: (context, itemIndex) {
                                        final item = orcamento.itens[itemIndex];
                                        return ListTile(
                                          title: Text(item.descricao),
                                          trailing: Text(
                                            "${item.valor.toStringAsFixed(2)} €",
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                          leading: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () =>
                                                controller.removerItem(
                                                    orcamento.id, item.id),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () =>
                                              controller.modalAdicionarItem(
                                                  context, orcamento.id),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => controller
                                              .removerOrcamento(orcamento.id),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Saldo Restante: ${saldoRestante.toStringAsFixed(2)} €",
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
                              ),
                            );
                          },
                        );
                      }
                    }),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        controller.modalAdicionarOrcamento(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("Adicionar"),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
