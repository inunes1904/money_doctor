import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';

import '../models/utilizador/utilizador.dart';

class UtilizadorRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Função para retornar os dados de um utilizador para o seu perfil
  Future<Utilizador?> getDadosUtilizador(String userId) async {
    final response =
        await _client.from('utilizadores').select().eq('id', userId).single();

    if (response.isEmpty) {
      // erro
      return null;
    } else {
      return Utilizador.fromJson(response);
    }
  }

  /// Função para alterar os dados de um utilizador
  Future<Either<String, bool>> alteraUtilizador(
      Utilizador novoUtilizador) async {
    try {
      final response = await _client
          .from('utilizadores')
          .update(novoUtilizador.toJson())
          .eq('id', novoUtilizador.id);

      if (response.error != null) {
        return left(response.error!.message);
      } else {
        return right(response.data['id'] != null);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
