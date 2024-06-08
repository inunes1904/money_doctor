import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/button.utils.dart';
import '../../../../widgets/header/header.dart';
import 'detalhesPartilhas.controller.dart';

class DetalhesPartilhasPage extends GetView<DetalhesPartilhasController> {
  const DetalhesPartilhasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarPublic(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final bool isCriador = controller.evento.value.criadorId ==
                  controller.storedUserId.value;
              final bool isSaldado = controller.utilizadores.any(
                  (u) => u.id == controller.storedUserId.value && u.saldado);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        controller.evento.value.nome,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 10),
                     Text(
                      "Descrição da Despesa Partilhada",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      controller.evento.value.descricao,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Transações",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    if (controller.transacoes.isNotEmpty)
                      ...controller.transacoes.map((transacao) {
                        final utilizador = controller.utilizadores
                            .firstWhere((u) => u.id == transacao.utilizadorId);
                        return Card(
                          child: ListTile(
                            title: Text(transacao.descricao),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${transacao.valor.toStringAsFixed(2)} €",
                                  style: TextStyle(
                                    color: transacao.valor > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Text(DateFormat('dd/MM/yyyy - HH:mm:ss')
                                    .format(transacao.dataTransacao)),
                                Text(transacao.pago
                                    ? "Pago por ${utilizador.username}"
                                    : "Não Pago"),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () async => await controller
                                  .eliminarDespesa(transacao.id),
                            ),
                          ),
                        );
                      })
                    else
                      const Text(
                          "Não existem despesas adicionadas nesta partilha."),
                    const SizedBox(height: 10),
                    controller.evento.value.status
                        ? // Adicionar Despesa
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ButtonUtils.getElevatedButtons(context,
                              styleElevatedButton: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.green),
                              ),
                              textElevatedButton: "Adicionar Despesa",
                              functionElevatedButton: () =>
                                  controller.adicionarDespesa(context),
                              elevatedButtonIcon: Icons.add_shopping_cart),
                        )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 30),
                    Text(
                      "Valor Total: ${controller.valorTotal.toStringAsFixed(2)} €",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    if (isCriador && controller.evento.value.status) ...[
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          Text(
                            "Gestão da Despesa Partilhada",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Adicionar Utilizador
                          Row(
                            children: [
                              SizedBox(
                                width: 190,
                                child: ButtonUtils.getElevatedButtons(context,
                                    styleElevatedButton: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                    ),
                                    textElevatedButton: "Utilizador",
                                    functionElevatedButton: () =>
                                        controller.adicionarUtilizador(context),
                                    elevatedButtonIcon: Icons.person_add),
                              ),
                                  const Spacer(),
                                  // Remover Utilizador
                              SizedBox(
                                width: 190,
                                child: ButtonUtils.getElevatedButtons(context,
                                    styleElevatedButton: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                    textElevatedButton: "Utilizador",
                                    functionElevatedButton: () =>
                                        controller.removerUtilizador(context),
                                    elevatedButtonIcon: Icons.person_remove),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          // Encerrar Despesa
                          ButtonUtils.getElevatedButtons(context,
                              styleElevatedButton: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              textElevatedButton: "Encerrar Despesa",
                              functionElevatedButton: () =>
                                  controller.encerrarEvento(),
                              elevatedButtonIcon: Icons.cancel),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      "Divisão das Despesas",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    ...controller.calculoDespesas.map((linha) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          linha,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }),
                      // Liquidar
                    if (!controller.evento.value.status && !isSaldado)
                      ButtonUtils.getElevatedButtons(context,
                          styleElevatedButton: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                controller.valorAPagar.value > 0
                                    ? Colors.red
                                    : Colors.green),
                          ),
                          textElevatedButton: "Liquidar",
                          functionElevatedButton: () =>
                              controller.liquidarDespesa(),
                          elevatedButtonIcon: Icons.check_circle),
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
