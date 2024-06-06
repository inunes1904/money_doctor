import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
                    Text(
                      controller.evento.value.nome,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      controller.evento.value.descricao,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Transações",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    if (controller.transacoes.isNotEmpty)
                      ...controller.transacoes.map((transacao) {
                        final utilizador = controller.utilizadores.firstWhere(
                            (u) => u.id == transacao.utilizadorId);
                        return Card(
                          child: ListTile(
                            title: Text(transacao.descricao),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DateFormat('dd/MM/yyyy - HH:mm:ss')
                                    .format(transacao.dataTransacao)),
                                Text(transacao.pago
                                    ? "Pago por ${utilizador.username}"
                                    : "Não Pago"),
                              ],
                            ),
                            trailing: Text(
                              "${transacao.valor.toStringAsFixed(2)} €",
                              style: TextStyle(
                                color: transacao.valor > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        );
                      })
                    else
                      const Text(
                          "Não existem despesas adicionadas nesta partilha."),
                    const SizedBox(height: 10),
                    controller.evento.value.status
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  controller.adicionarDespesa(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text('Adicionar Despesa'),
                            ),
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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  controller.adicionarUtilizador(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text('Adicionar Utilizador'),
                            ),
                          ),
                          // const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.encerrarEvento,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text('Encerrar Despesa'),
                            ),
                          ),
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
                    if (!controller.evento.value.status && !isSaldado)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.liquidarDespesa,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text('Liquidar'),
                        ),
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
