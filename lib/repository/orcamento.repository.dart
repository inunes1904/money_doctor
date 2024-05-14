import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import '../models/utilizador/orcamento_item.dart';
import '../models/utilizador/orcamento.dart';

class OrcamentoRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Either<String, List<Orcamento>>> carregarOrcamentos(String utilizadorId) async {
    try {
      final List<dynamic> response = await _client
          .from('orcamentos')
          .select('*, itens_orcamento(*)')
          .eq('utilizador_id', utilizadorId);

      if (response.isNotEmpty) {
        List<Orcamento> orcamentos = List<Orcamento>.from(
          response.map((x) => Orcamento.fromJson(x))
        );
        return right(orcamentos);
      } else {
        return left('Nenhum dado encontrado');
      }
    } catch (e) {
      return left('Erro ao carregar orçamentos: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> adicionarOrcamento(Orcamento orcamento) async {
    try {
      await _client
          .from('orcamentos')
          .insert(orcamento.toJson())
          .select();

      return right(true);
    } catch (e) {
      return left('Erro ao adicionar orçamento: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> removerOrcamento(String orcamentoId) async {
    try {
       await _client
          .from('orcamentos')
          .delete()
          .eq('id', orcamentoId)
          .select();

      return right(true);
    } catch (e) {
      return left('Erro ao remover orçamento: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> adicionarItem(ItemOrcamento item) async {
    try {
      await _client
          .from('itens_orcamento')
          .insert(item.toJson())
          .select();

      return right(true);
    } catch (e) {
      return left('Erro ao adicionar item: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> removerItem(String itemId) async {
    try {
      await _client
          .from('itens_orcamento')
          .delete()
          .eq('id', itemId)
          .select();

      return right(true);
    } catch (e) {
      return left('Erro ao remover item: ${e.toString()}');
    }
  }
}
