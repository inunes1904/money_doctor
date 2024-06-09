import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../styles/global.colors.dart';
import '../../../widgets/header/header.dart';
import '../../../widgets/menu/side_menu.page.dart';
import 'resumoFinanceiro.controller.dart';

class ResumoFinanceiroPage extends GetView<ResumoFinanceiroController> {
  const ResumoFinanceiroPage({super.key});

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
                  Text('Resumo Financeiro',
                      style: Theme.of(context).textTheme.titleLarge!),
                  const SizedBox(height: 10),
                  Obx(() => controller.saldos.isEmpty
                      ? Center(
                          child: Text(controller.mensagemSaldo.isNotEmpty
                              ? controller.mensagemSaldo.value
                              : 'A carregar saldo...'))
                      : Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Saldo Total',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${controller.saldos.first.saldo.toStringAsFixed(2)} €',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  const SizedBox(height: 20),
                  const Text(
                    'Investimentos em Aberto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Obx(() => controller.investimentos.isEmpty
                      ? Center(
                          child: Text(
                          controller.mensagemInvestimentos.isNotEmpty
                              ? controller.mensagemInvestimentos.value
                              : 'A carregar investimentos...',
                          style: const TextStyle(fontSize: 14),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.investimentos.length,
                          itemBuilder: (context, index) {
                            final investimento =
                                controller.investimentos[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  investimento.tipo,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${investimento.valor.toStringAsFixed(2)} €',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          },
                        )),
                  const SizedBox(height: 20),
                  const Text(
                    'Despesas Partilhadas em Aberto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Obx(() => controller.eventos.isEmpty
                      ? Center(
                          child: Text(
                          controller.mensagemDespesasPartilhadas.isNotEmpty
                              ? controller.mensagemDespesasPartilhadas.value
                              : 'A carregar despesas partilhadas...',
                          style: const TextStyle(fontSize: 14),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.eventos.length,
                          itemBuilder: (context, index) {
                            final evento = controller.eventos[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  evento.nome,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  evento.descricao,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          },
                        )),
                ],
              ),
            );
          }
        }),
      ),
    ));
  }
}
