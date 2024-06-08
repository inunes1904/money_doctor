import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/button.utils.dart';
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
                    "Visão Geral do Saldo",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.saldos.isEmpty) {
                      return const Center(
                          child: Text("Nenhum saldo registado."));
                    } else {
                      final saldo = controller.saldos.first;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width <
                                    MediaQuery.of(context).size.height
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.height,
                            height: MediaQuery.of(context).size.width <
                                    MediaQuery.of(context).size.height
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.height,
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
                            "Atualizado em: ${DateFormat('dd/MM/yyyy - HH:mm:ss').format(saldo.dataAtualizacao)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Acções",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(color: Colors.black54),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                width: 150,
                                child: ButtonUtils.getElevatedButtons(context,
                                    styleElevatedButton: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                    ),
                                    textElevatedButton: "Saldo",
                                    functionElevatedButton: () =>
                                        controller.modalAdicionarRemover(
                                                context, "Adicionar"),
                                    elevatedButtonIcon: Icons.add),
                              ),
                              SizedBox(
                                width: 150,
                                child: ButtonUtils.getElevatedButtons(context,
                                    styleElevatedButton: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                    textElevatedButton: "Saldo",
                                    functionElevatedButton: () =>
                                        controller.modalAdicionarRemover(
                                                context, "Remover"),
                                    elevatedButtonIcon: Icons.remove),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Movimentos de saldo",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(color: Colors.black54),
                                  ),
                                ),
                                Obx(() {
                                  if (controller.saldos.isEmpty) {
                                    return const Center(
                                        child: Text(
                                            "Nenhuma transação registada."));
                                  } else {
                                    final transacoes =
                                        controller.saldos.first.transacoes;
                                    transacoes.sort((a, b) => b.dataTransacao
                                        .compareTo(a.dataTransacao));
                                    return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: transacoes.length,
                                      itemBuilder: (context, index) {
                                        final transacao = transacoes[index];
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    transacao.valor > 0
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
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                DateFormat(
                                                        'dd/MM/yyyy - HH:mm:ss')
                                                    .format(transacao
                                                        .dataTransacao),
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                              trailing: Text(
                                                "${transacao.valor.toStringAsFixed(2)} €",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: transacao.valor > 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                            ),
                                            const Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                  const SizedBox(height: 20),
                ],
              ));
            }
          }),
        ),
      ),
    );
  }
}
