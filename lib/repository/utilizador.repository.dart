import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';

import '../models/utilizador/utilizador.dart';
import '../styles/global.colors.dart';
import 'authentication.repository.dart';

class UtilizadorRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final AuthenticationRepository _repoAuth = AuthenticationRepository();


  /// Função para retornar os dados de um utilizador para o seu perfil
  Future<Utilizador?> getDadosUtilizador(String userId) async {
    try {
      var response = await _client.from('utilizadores').select().eq('id', userId).single();
      return Utilizador.fromJson(response);

    } catch (e) {
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Ocorreu um erro',
          text: "Ocorreu um erro ao executar a tarefa que solicitou. Por favor, verifique a sua ligação à internet. Caso o problema persista, entre em contacto com a nossa equipa.",
          confirmBtnText: 'Ok',
          confirmBtnColor: GlobalColors.dangerColor,
        );
       await _repoAuth.logout();
      return null;
    }
  }

  /// Função para alterar os dados de um utilizador
  Future<Either<String, bool>> alteraUtilizador(
      Utilizador novoUtilizador) async {
    try {
      await _client
          .from('utilizadores')
          .update(novoUtilizador.toJson())
          .eq('id', novoUtilizador.id);

      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> alterarEmailPassword(
      {required String email, required String password}) async {
    try {
      UserAttributes alterarPassPedido =
          UserAttributes(email: email, password: password);
      await _client.auth.updateUser(alterarPassPedido);
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }
}
