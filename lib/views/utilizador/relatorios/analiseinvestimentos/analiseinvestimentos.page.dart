import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/header/header.dart';
import 'analiseinvestimentos.controller.dart';

class AnaliseInvestimentosPage extends GetView<AnaliseInvestimentosController> {
  const AnaliseInvestimentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarPublic(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Análise de Investimentos',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => DropdownButton<int>(
                          value: controller.selectedMonth.value,
                          items: List.generate(12, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text(DateFormat('MMMM')
                                  .format(DateTime(0, index + 1))),
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
                            return DropdownMenuItem<int>(
                              value: DateTime.now().year - index,
                              child: Text(
                                  (DateTime.now().year - index).toString()),
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
                  } else if (controller.investimentos.isEmpty) {
                    return const Center(
                        child: Text("Não há dados disponíveis."));
                  } else {
                    final investimentos = controller.investimentos
                        .where((investimento) =>
                            investimento.dataInvestimento!.year ==
                                controller.selectedYear.value &&
                            investimento.dataInvestimento!.month ==
                                controller.selectedMonth.value)
                        .toList();

                    if (investimentos.isEmpty) {
                      return const Center(
                          child:
                              Text("Não há dados disponíveis neste período."));
                    }

                    double totalInvestido = 0;
                    double totalRetorno = 0;
                    double retornoTotal = 0;

                    return Column(
                      children: [
                        ...investimentos.map((investimento) {
                          final historico =
                              controller.historicoInvestimentos[investimento.id];
                          final valorFinal =
                              historico?.valorFinal ?? investimento.valor;
                          final lucro = valorFinal - investimento.valor;
                          final lucroColor = lucro > 0
                              ? Colors.green
                              : (lucro < 0 ? Colors.red : Colors.grey);
                          final lucroIcon = lucro > 0
                              ? Icons.arrow_upward
                              : (lucro < 0 ? Icons.arrow_downward : Icons.remove);

                          totalInvestido += investimento.valor;
                          totalRetorno += valorFinal;
                          retornoTotal += lucro;

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(investimento.descricao,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: lucroColor,
                                      child: Icon(lucroIcon, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Resultado: ${lucro.toStringAsFixed(2)} €",
                                      style: TextStyle(
                                          fontSize: 16, color: lucroColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    "Valor Investido: ${investimento.valor.toStringAsFixed(2)} €",
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 8),
                                Text(
                                  historico?.dataRetirada != null
                                      ? "Valor Retorno: ${valorFinal.toStringAsFixed(2)} €"
                                      : "Valor Atual: ${valorFinal.toStringAsFixed(2)} €",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    "Data de Investimento: ${DateFormat('dd/MM/yyyy').format(investimento.dataInvestimento!)}",
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 8),
                                Text(
                                  historico?.dataRetirada != null
                                      ? "Data de Liquidação: ${DateFormat('dd/MM/yyyy').format(historico!.dataRetirada!)}"
                                      : "Ainda Investido",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 20.0),
                                const Divider(height: 1, color: Colors.grey),
                              ],
                            ),
                          );
                        }),
                        // Totals
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Valor Total Investido: ${totalInvestido.toStringAsFixed(2)} €", style: const TextStyle(fontSize: 14,)),
                              const SizedBox(height: 8),
                              Text("Valor Total Retorno: ${totalRetorno.toStringAsFixed(2)} €", style: const TextStyle(fontSize: 14,)),
                              const SizedBox(height: 8),
                              Text("Retorno Total: ${retornoTotal.toStringAsFixed(2)} €", style: const TextStyle(fontSize: 14,)),
                            ],
                          ),
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
