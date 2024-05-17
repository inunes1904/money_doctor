import 'package:get/get.dart';
import '../../../models/storage_item.dart';
import '../../../models/utilizador/utilizador.dart';
import '../../../repository/utilizador.repository.dart';
import '../../../services/storage_service.dart';

class DadosUtilizadorController extends GetxController {
  final Rx<Utilizador?> utilizador = Rx<Utilizador?>(null);
  final StorageService _storage = StorageService();
  final UtilizadorRepository utilizadorRepo = UtilizadorRepository();
  RxString nomeProprio = ''.obs;
  RxString username = ''.obs;
  RxBool isLoading = RxBool(true);
  RxBool hasError = RxBool(false);
  RxString storedUserId = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
    await carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    isLoading(true);
    hasError(false);
    update();

    if (storedUserId.value != "") {
      Utilizador? dados =
          await utilizadorRepo.getDadosUtilizador(storedUserId.value);
      if (dados != null) {
        utilizador(dados);
        nomeProprio(dados.nomeProprio);
        username(dados.username);
      } else {
        hasError(true);
      }
      isLoading(false);
      update();
    }
  }

  Future<void> atualizarDados() async {
    if (utilizador.value != null) {
      isLoading(true);
      update();
      
      Utilizador updatedUser = Utilizador(
        id: utilizador.value!.id,
        nomeProprio: nomeProprio.value,
        email: utilizador.value!.email,
        username: username.value,
        ultimoAcesso: utilizador.value!.ultimoAcesso,
      );

      await utilizadorRepo.alteraUtilizador(updatedUser);
        // Atualizar dados localmente e mostrar mensagem de sucesso/erro
        await _storage
          .writeSecureData(StorageItem("nomeProprio", nomeProprio.value));
        await _storage.writeSecureData(StorageItem("username", username.value));
        await carregarDadosUsuario(); // Recarregar dados do usuário após a atualização

      isLoading(false);
      update();
    }
  }
}
