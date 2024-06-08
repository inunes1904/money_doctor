import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/button.utils.dart';
import '../../../widgets/header/header.dart';
import '../../../widgets/menu/side_menu.page.dart';
import 'partilhas.controller.dart';

class PartilhasPage extends GetView<PartilhasController> {
  const PartilhasPage({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Despesas Partilhadas",
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        value: controller.filtroAtual.value,
                        items: <String>['Todas', 'Ativas', 'Encerradas']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            controller.filtrarEventos(newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (controller.eventosFiltrados.isEmpty) {
                        return Center(
                            child: Text(controller.filtroAtual.value == "Todas"
                                ? "Não existem despesas partilhadas."
                                : "Não existem despesas ${controller.filtroAtual.value.toLowerCase()}."));
                      } else {
                        return Column(
                          children: controller.eventosFiltrados.map((evento) {
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Center(
                                    child: Text(evento.nome,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!)),
                                subtitle: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: [
                                        Text("Descrição: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!),
                                        Text(evento.descricao),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Estado: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!),
                                        Text(
                                          evento.status ? 'Ativa' : 'Encerrada',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: evento.status
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () =>
                                    controller.verDetalhesEvento(evento),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8.0),
                      child: ButtonUtils.getElevatedButtons(context,
                          styleElevatedButton: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          textElevatedButton: "Criar Despesa Partilhada",
                          functionElevatedButton: () =>
                              controller.criarEvento(context),
                          elevatedButtonIcon: Icons.add),
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
