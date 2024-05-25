import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/header/header.dart';
import 'despesasmensais.controller.dart';

class DespesasMensaisPage extends GetView<DespesasMensaisController> {
  const DespesasMensaisPage({super.key});

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
                Text('Despesas Mensais',
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
                        child: Text("Nenhuma despesa registada."));
                  } else {
                    final transacoes = controller.saldos.first.transacoes
                        .where((transacao) =>
                            transacao.valor < 0 &&
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
                              Text("Nenhuma despesa registada neste período."));
                    }

                    Map<int, double> dailyExpenses = {};
                    for (var transacao in transacoes) {
                      int day = transacao.dataTransacao.day;
                      if (dailyExpenses.containsKey(day)) {
                        dailyExpenses[day] =
                            dailyExpenses[day]! + transacao.valor.abs();
                      } else {
                        dailyExpenses[day] = transacao.valor.abs();
                      }
                    }

                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.5,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: dailyExpenses.values.reduce(
                                  (value, element) =>
                                      value > element ? value : element),
                              barGroups: dailyExpenses.entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                        y: entry.value, colors: [Colors.red])
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  getTitles: (value) {
                                    return value.toInt().toString();
                                  },
                                ),
                                leftTitles: SideTitles(showTitles: true),
                              ),
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
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.red),
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
