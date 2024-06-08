import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneydoctor/routes/app_routes.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../models/utilizador/evento.dart';
import '../../../../models/utilizador/evento_transacao.dart';
import '../../../../models/utilizador/evento_utilizador.dart';
import '../../../../models/utilizador/utilizador.dart';
import '../../../../repository/evento.repository.dart';
import '../../../../repository/saldo.repository.dart';
import '../../../../services/storage_service.dart';
import '../../../../styles/global.colors.dart';

class DetalhesPartilhasController extends GetxController {
  final EventoRepository _repo = EventoRepository();
  final SaldoRepository _saldoRepo = SaldoRepository();
  final StorageService _storage = StorageService();
  Rx<Evento> evento = Evento(
    id: '',
    nome: '',
    descricao: '',
    criadorId: '',
    status: true,
    dataCriacao: DateTime.now(),
  ).obs;
  RxList<TransacaoPartilha> transacoes = <TransacaoPartilha>[].obs;
  RxList<UtilizadorPartilha> utilizadores = <UtilizadorPartilha>[].obs;
  RxList<Utilizador> todosUtilizadores = <Utilizador>[]
      .obs; // vão popular dropdownlist para adicionar utilizador à despesa
  RxBool isLoading = RxBool(true);
  RxDouble valorTotal = 0.0.obs;
  RxDouble valorAPagar = 0.0.obs;
  RxString storedUserId = "".obs;
  RxString storedUsername = "".obs;
  RxList<String> calculoDespesas = <String>[].obs;
  RxString selectedUser = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    storedUsername.value = await _storage.readSecureData("username") ?? "";
    if (Get.arguments != null) {
      evento.value = Get.arguments as Evento;
      await carregarDetalhesEvento();
      await carregarTodosUtilizadores();
      await calcularDivisaoDespesas();
    }
  }

  Future<void> carregarTodosUtilizadores() async {
    final result = await _repo.carregarTodosUtilizadores();
    result.match(
      (l) => todosUtilizadores.value = [],
      (r) {
        todosUtilizadores.value = r;
        todosUtilizadores.removeWhere((user) =>
            utilizadores.any((u) => u.id == user.id) ||
            user.id == evento.value.criadorId);
      },
    );
  }

  Future<void> carregarDetalhesEvento() async {
    isLoading(true);
    final resultTransacoes =
        await _repo.carregarTransacoesPartilha(evento.value.id);
    resultTransacoes.match(
      (l) => transacoes.value = [],
      (r) => transacoes.value = r,
    );

    final resultUtilizadores =
        await _repo.carregarUtilizadoresPartilha(evento.value.id);
    resultUtilizadores.match(
      (l) => utilizadores.value = [],
      (r) => utilizadores.value = r,
    );

    calcularValorTotal();
    isLoading(false);
  }

  void calcularValorTotal() {
    valorTotal.value =
        transacoes.fold(0.0, (sum, transacao) => sum + transacao.valor);
  }

  void adicionarDespesa(context) async {
    TextEditingController valorController = TextEditingController();
    TextEditingController descricaoController = TextEditingController();
    RxBool pago = false.obs;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Despesa Partilhada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => CheckboxListTile(
                      title: const Text("Pago"),
                      value: pago.value,
                      onChanged: (value) {
                        pago.value = value!;
                      },
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (valorController.text.isNotEmpty &&
                          descricaoController.text.isNotEmpty) {
                        final valor =
                            double.tryParse(valorController.text) ?? 0.0;
                        final result = await _repo.adicionarDespesa(
                          evento.value.id,
                          storedUserId.value,
                          valor,
                          descricaoController.text,
                          pago.value,
                        );
                        if (pago.value) {
                          await _saldoRepo.atualizarSaldo(
                            storedUserId.value,
                            valor,
                            false,
                            'Despesa Partilhada: ${descricaoController.text}',
                          );
                        }
                        result.match(
                            (l) => QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Erro ao Adicionar Despesa',
                                  text: l,
                                  confirmBtnText: 'Ok',
                                  confirmBtnColor: Colors.red,
                                ),
                            (r) => {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      title: 'Despesa adicionada com sucesso!',
                                      text:
                                          "Adicionou uma despesa específica à Partilha.",
                                      confirmBtnText: 'Ok',
                                      confirmBtnColor:
                                          GlobalColors.successColor,
                                      onConfirmBtnTap: () => {
                                            closeAndRefresh(),
                                          })
                                });
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
                    child: const Text("Adicionar"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
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

  void adicionarUtilizador(context) async {
    selectedUser.value =
        todosUtilizadores.isNotEmpty ? todosUtilizadores.first.id : '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Criar Despesa Partilhada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Adicionar Utilizador",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: selectedUser.value != ""
                        ? DropdownButton<String>(
                            value: selectedUser.value,
                            isExpanded: true,
                            onChanged: (newValue) {
                              selectedUser.value = newValue ?? '';
                            },
                            items: todosUtilizadores.map((utilizador) {
                              return DropdownMenuItem<String>(
                                value: utilizador.id,
                                child: SizedBox(
                                    width: 320,
                                    child: Text(utilizador.username)),
                              );
                            }).toList(),
                          )
                        : const Text("Não foram encontrados utilizadores"),
                  );
                }),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedUser.value.isNotEmpty) {
                        final result =
                            await _repo.adicionarUtilizadorPartilhaEvento(
                                evento.value.id, selectedUser.value);
                        result.match(
                          (l) => QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Erro ao Adicionar Utilizador',
                            text: l,
                            confirmBtnText: 'Ok',
                            confirmBtnColor: Colors.red,
                          ),
                          (r) => {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              title: 'Utilizador adicionado com sucesso!',
                              text:
                                  "O utilizador adicionado será responsável pela divisão desta despesa.",
                              confirmBtnText: 'Ok',
                              confirmBtnColor: GlobalColors.successColor,
                              onConfirmBtnTap: () => {closeAndRefresh()},
                            )
                          },
                        );
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
                    child: const Text("Adicionar"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
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

  void removerUtilizador(context) async {
    selectedUser.value =
        utilizadores.where((u) => u.id != evento.value.criadorId).isNotEmpty
            ? utilizadores.firstWhere((u) => u.id != evento.value.criadorId).id
            : '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Criar Despesa Partilhada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Remover Utilizador",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: selectedUser.value != ""
                        ? DropdownButton<String>(
                            value: selectedUser.value,
                            isExpanded: true,
                            onChanged: (newValue) {
                              selectedUser.value = newValue ?? '';
                            },
                            items: utilizadores
                                .where((utilizador) =>
                                    utilizador.id != evento.value.criadorId)
                                .map((utilizador) {
                              return DropdownMenuItem<String>(
                                value: utilizador.id,
                                child: SizedBox(
                                    width: 320,
                                    child: Text(utilizador.username)),
                              );
                            }).toList(),
                          )
                        : const Text("Não foram encontrados utilizadores"),
                  );
                }),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedUser.value.isNotEmpty) {
                        final result =
                            await _repo.removerUtilizadorPartilhaEvento(
                                evento.value.id, selectedUser.value);
                        result.match(
                          (l) => QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Erro ao Remover Utilizador',
                            text: l,
                            confirmBtnText: 'Ok',
                            confirmBtnColor: Colors.red,
                          ),
                          (r) => {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              title: 'Utilizador removido com sucesso!',
                              text:
                                  "O utilizador foi removido da divisão desta despesa.",
                              confirmBtnText: 'Ok',
                              confirmBtnColor: GlobalColors.successColor,
                              onConfirmBtnTap: () => {closeAndRefresh()},
                            )
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("Remover"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
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

  void encerrarEvento() async {
    final result = await _repo.alterarStatusEvento(evento.value.id, false);
    result.match(
      (l) => QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Encerrar Despesa Partilhada',
        text: l,
        confirmBtnText: 'Ok',
        confirmBtnColor: Colors.red,
      ),
      (r) {
        evento.update((val) {
          val!.status = false;
        });
        calcularDivisaoDespesas();
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          title: 'Despesa Partilhada Encerrada',
          text: calcularMensagemDivisaoDespesas(),
          confirmBtnText: 'Ok',
          confirmBtnColor: Colors.green,
        );
      },
    );
  }

  void liquidarDespesa() async {
    final utilizador =
        utilizadores.firstWhere((u) => u.id == storedUserId.value);

    if (valorAPagar.value > 0) {
      await _saldoRepo.atualizarSaldo(
        utilizador.id,
        valorAPagar.value,
        false,
        'Pagamento da parte da despesa partilhada',
      );
    } else if (valorAPagar.value < 0) {
      await _saldoRepo.atualizarSaldo(
        utilizador.id,
        -valorAPagar.value,
        true,
        'Recebimento da parte da despesa partilhada',
      );
    }

    await _repo.atualizarSaldado(utilizador.id, evento.value.id, true);

    calcularDivisaoDespesas();

    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.success,
      title: 'Despesas Liquidadas',
      text: 'As despesas foram liquidadas com sucesso.',
      confirmBtnText: 'Ok',
      confirmBtnColor: GlobalColors.successColor,
      onConfirmBtnTap: () => Get.offAllNamed(AppRoutes.partilhas)
    );
  }

  Future<void> calcularDivisaoDespesas() async {
    final int numUtilizadores = utilizadores.length;

    // Calcula o valor total das despesas
    final double valorTotal =
        transacoes.fold(0.0, (sum, transacao) => sum + transacao.valor);

    // Divide o valor total igualmente entre todos os utilizadores
    final double valorPorPessoa = valorTotal / numUtilizadores;

    calculoDespesas.clear();

    for (var utilizador in utilizadores) {
      double valorPago = transacoes
          .where((t) => t.utilizadorId == utilizador.id && t.pago)
          .fold(0.0, (sum, transacao) => sum + transacao.valor);

      // Calcula o valor que o utilizador deve pagar ou receber
      double diferenca = valorPorPessoa - valorPago;

      if (utilizador.id == storedUserId.value) {
        valorAPagar.value =
            diferenca; // valor a pagar guardado para ser liquidado no saldo pessoal
      }

      if (utilizador.saldado) {
        calculoDespesas.add('${utilizador.username} já liquidou sua parte.');
      } else {
        if (diferenca > 0) {
          calculoDespesas.add(
              '${utilizador.username} tem a pagar ${diferenca.toStringAsFixed(2)} €');
        } else if (diferenca < 0) {
          calculoDespesas.add(
              '${utilizador.username} tem a receber ${(-diferenca).toStringAsFixed(2)} €');
        } else {
          calculoDespesas.add(
              '${utilizador.username} não tem valores a pagar nem a receber');
        }
      }
    }
  }

  String calcularMensagemDivisaoDespesas() {
    return calculoDespesas.join('\n');
  }

  Future<void> eliminarDespesa(String transacaoId) async {
    final transacao = transacoes.firstWhere((t) => t.id == transacaoId);
    if (transacao.utilizadorId == storedUserId.value ||
        evento.value.criadorId == storedUserId.value) {
      final result = await _repo.eliminarDespesa(transacaoId);
      result.match(
        (l) => QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Erro ao Eliminar Transação',
          text: l,
          confirmBtnText: 'Ok',
          confirmBtnColor: Colors.red,
        ),
        (r) async {
          // Devolver o valor ao utilizador se a transação estava paga
          if (transacao.pago) {
            await _saldoRepo.atualizarSaldo(
              transacao.utilizadorId,
              transacao.valor,
              true,
              'Devolução de valor da transação eliminada ${transacao.descricao}',
            );
          }
          transacoes.removeWhere((t) => t.id == transacaoId);

          calcularValorTotal();
          calcularDivisaoDespesas();
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: 'Transação Eliminada',
            text: 'A transação foi eliminada com sucesso.',
            confirmBtnText: 'Ok',
            confirmBtnColor: Colors.green,
          );
        },
      );
    } else {
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Erro ao Eliminar Transação',
        text:
            'Apenas o criador da despesa partilhada ou o utilizador que inseriu a transação pode eliminá-la.',
        confirmBtnText: 'Ok',
        confirmBtnColor: Colors.red,
      );
    }
  }

  void closeAndRefresh() async {
    Get.back();
    Get.back();
    await carregarDetalhesEvento();
    await carregarTodosUtilizadores();
    await calcularDivisaoDespesas();
  }
}
