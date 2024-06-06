import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  children: [
                    Text(
                      "Despesas Partilhadas",
                      style: Theme.of(context).textTheme.titleLarge!,
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
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
                                title: Text(evento.nome),
                                subtitle: Text(
                                  "${evento.descricao}\nStatus: ${evento.status ? 'Ativo' : 'Encerrado'}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onTap: () =>
                                    controller.verDetalhesEvento(evento),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () => controller.criarEvento(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Criar Despesa Partilhada'),
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
