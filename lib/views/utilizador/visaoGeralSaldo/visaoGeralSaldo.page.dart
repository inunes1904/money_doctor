import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Visão Geral do Saldo",
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height,
                          height: MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.greenAccent.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "${saldo.saldo.toStringAsFixed(2)} €",
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Atualizado em: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(saldo.dataAtualizacao)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }
                }),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: controller.valorController,
                          decoration: const InputDecoration(
                            labelText: 'Valor',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controller.descricaoController,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            border: OutlineInputBorder(),
                          ),
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
                                  final valor = double.tryParse(
                                          controller.valorController.text) ??
                                      0.0;
                                  controller.adicionarValor(
                                    double.parse(valor.toStringAsFixed(2)),
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
                                  final valor = double.tryParse(
                                          controller.valorController.text) ??
                                      0.0;
                                  controller.retirarValor(
                                    double.parse(valor.toStringAsFixed(2)),
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
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            controller.valorController.clear();
                            controller.descricaoController.clear();
                          },
                          child: const Text("Limpar"),
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
                    transacoes.sort(
                        (a, b) => b.dataTransacao.compareTo(a.dataTransacao));

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: transacoes.length,
                      itemBuilder: (context, index) {
                        final transacao = transacoes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transacao.valor > 0
                                  ? Colors.green
                                  : Colors.red,
                              child: Icon(
                                transacao.valor > 0
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              transacao.descricao,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              DateFormat('dd/MM/yyyy HH:mm:ss')
                                  .format(transacao.dataTransacao),
                              style: const TextStyle(fontSize: 14),
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
            ),
          ),
        ),
      ),
    );
  }
}
