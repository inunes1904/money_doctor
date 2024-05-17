import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/global.colors.dart';
import '../../../widgets/header/header.dart';
import '../../../widgets/menu/side_menu.page.dart';
import 'visaoGeralSaldo.controller.dart';

class VisaoGeralSaldoPage extends GetView<VisaoGeralSaldoController> {
  const VisaoGeralSaldoPage({super.key});

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
              children: [
                Text(
                  'Visão Geral do Saldo',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  if (controller.saldos.isEmpty) {
                    return const Center(child: Text("Nenhum saldo registado."));
                  } else {
                    final saldo = controller.saldos.first;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.blueAccent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${saldo.saldo} €",
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Atualizado em: ${saldo.dataAtualizacao}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: controller.valorController,
                                decoration: InputDecoration(
                                  labelText: 'Valor',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      controller.valorController.clear();
                                    },
                                  ),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: controller.descricaoController,
                                decoration: InputDecoration(
                                  labelText: 'Descrição',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      controller.descricaoController.clear();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (controller
                                        .valorController.text.isNotEmpty &&
                                    controller
                                        .descricaoController.text.isNotEmpty) {
                                  controller.adicionarValor(
                                    double.parse(
                                        controller.valorController.text),
                                    controller.descricaoController.text,
                                  );
                                  controller.valorController.clear();
                                  controller.descricaoController.clear();
                                }
                              },
                              child: const Text("Adicionar"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (controller
                                        .valorController.text.isNotEmpty &&
                                    controller
                                        .descricaoController.text.isNotEmpty) {
                                  controller.retirarValor(
                                    double.parse(
                                        controller.valorController.text),
                                    controller.descricaoController.text,
                                  );
                                  controller.valorController.clear();
                                  controller.descricaoController.clear();
                                }
                              },
                              child: const Text("Retirar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.saldos.isEmpty) {
                    return const Center(
                        child: Text("Nenhuma transação registada."));
                  } else {
                    final transacoes = controller.saldos.first.transacoes;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transacoes.length,
                      itemBuilder: (context, index) {
                        final transacao = transacoes[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(transacao.descricao),
                            subtitle: Text(
                              "${transacao.dataTransacao}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              "${transacao.valor.toStringAsFixed(2)} €",
                              style: TextStyle(
                                fontSize: 16,
                                color: transacao.valor > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ],
            ));
          }
        }),
      ),
    ));
  }
}
