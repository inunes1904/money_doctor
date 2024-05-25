import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/header/header.dart';
import 'despesasvsreceitas.controller.dart';

class DespesasVsReceitasPage extends GetView<DespesasVsReceitasController> {
  const DespesasVsReceitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarPublic(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Despesas vs Receitas',
                    style: Theme.of(context).textTheme.titleLarge!),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => DropdownButton<int>(
                          value: controller.selectedMonth.value,
                          items: List.generate(12, (index) {
                            int month = index + 1;
                            return DropdownMenuItem<int>(
                              value: month,
                              child: Text(DateFormat('MMMM')
                                  .format(DateTime(0, month))),
                            );
                          }),
                          onChanged: (value) {
                            if (value != null) {
                              controller.filtrarPorAnoMes(
                                  controller.selectedYear.value, value);
                            }
                          },
                        )),
                    const SizedBox(width: 20),
                    Obx(() => DropdownButton<int>(
                          value: controller.selectedYear.value,
                          items: List.generate(10, (index) {
                            int year = DateTime.now().year - index;
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }),
                          onChanged: (value) {
                            if (value != null) {
                              controller.filtrarPorAnoMes(
                                  value, controller.selectedMonth.value);
                            }
                          },
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.saldos.isEmpty) {
                    return const Center(
                        child: Text("Não há dados disponíveis."));
                  } else {
                    final transacoes = controller.saldos.first.transacoes
                        .where((transacao) =>
                            transacao.dataTransacao.year ==
                                controller.selectedYear.value &&
                            transacao.dataTransacao.month ==
                                controller.selectedMonth.value)
                        .toList();
                    transacoes.sort(
                        (a, b) => a.dataTransacao.compareTo(b.dataTransacao));

                    if (transacoes.isEmpty) {
                      return const Center(
                          child:
                              Text("Não há dados disponíveis neste período."));
                    }

                    double totalDespesas = transacoes
                        .where((t) => t.valor < 0)
                        .fold(0.0, (sum, item) => sum + item.valor.abs());
                    double totalReceitas = transacoes
                        .where((t) => t.valor > 0)
                        .fold(0.0, (sum, item) => sum + item.valor);

                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.5,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: totalDespesas,
                                  title:
                                      '${(totalDespesas / (totalDespesas + totalReceitas) * 100).toStringAsFixed(1)}%',
                                  color: Colors.red,
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  value: totalReceitas,
                                  title:
                                      '${(totalReceitas / (totalDespesas + totalReceitas) * 100).toStringAsFixed(1)}%',
                                  color: Colors.green,
                                  radius: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: transacoes.length,
                          itemBuilder: (context, index) {
                            final transacao = transacoes[index];
                            return Column(
                              children: [
                                ListTile(
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                                            : Colors.red),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                ),
                                const Divider(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
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
