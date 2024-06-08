import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import '../../../models/utilizador/evento.dart';
import '../../../repository/evento.repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/storage_service.dart';
import '../../../styles/global.colors.dart';

class PartilhasController extends GetxController {
  final StorageService _storage = StorageService();
  final EventoRepository _repo = EventoRepository();
  final RxList<Evento> eventos = <Evento>[].obs;
  final RxList<Evento> eventosFiltrados = <Evento>[].obs;
  RxBool isLoading = RxBool(true);
  RxBool isLoadingCreateCall = RxBool(false);
  RxString storedUserId = "".obs;
  RxString storedUsername = "".obs;
  RxString filtroAtual = 'Todas'.obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    storedUsername.value = await _storage.readSecureData("username") ?? "";
    await carregarEventos();
  }

  Future<void> carregarEventos() async {
    isLoading(true);
    if (storedUserId.value.isNotEmpty) {
      final result = await _repo.carregarEventos(storedUserId.value);
      result.match(
        (l) => eventos.value = [],
        (r) => eventos.value = r,
      );
      filtrarEventos(filtroAtual.value);
    }
    isLoading(false);
  }

  void filtrarEventos(String filtro) {
    filtroAtual.value = filtro;
    if (filtro == 'Ativas') {
      eventosFiltrados.value =
          eventos.where((evento) => evento.status).toList();
    } else if (filtro == 'Encerradas') {
      eventosFiltrados.value =
          eventos.where((evento) => !evento.status).toList();
    } else {
      eventosFiltrados.value = eventos;
    }
  }

  Future<void> criarEvento(context) async {
    TextEditingController nomeController = TextEditingController();
    TextEditingController descricaoController = TextEditingController();

showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Criar Despesa Partilhada'),
          content:  SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Despesa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição da Despesa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (isLoadingCreateCall.value)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      isLoadingCreateCall.value = true;
                      if (nomeController.text.isNotEmpty) {
                        final result = await _repo.criarEvento(
                          nomeController.text,
                          descricaoController.text,
                          storedUserId.value,
                          true,
                        );
                        result.match(
                          (l) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Erro ao Criar Despesa Partilhada',
                              text: l,
                              confirmBtnText: 'Ok',
                              confirmBtnColor: GlobalColors.dangerColor,
                            );
                          },
                          (r) {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                title: 'Despesa Partilhada criada com sucesso!',
                                text:
                                    "Aceda aos detalhes da despesa para adicionar utilizadores e os gastos que partilham.",
                                confirmBtnText: 'Ok',
                                confirmBtnColor: GlobalColors.successColor,
                                onConfirmBtnTap: () =>
                                    {Get.offAllNamed(AppRoutes.partilhas)});
                          },
                        );
                        isLoadingCreateCall.value = false;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("Criar"),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Cancelar"),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );

  }

  void verDetalhesEvento(Evento evento) {
    Get.toNamed(AppRoutes.detalhesPartilhas, arguments: evento);
  }
}
