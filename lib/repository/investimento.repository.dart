import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import '../../../models/utilizador/investimento.dart';

class InvestimentoRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Either<String, List<Investimento>>> carregarInvestimentos(String utilizadorId) async {
    try {
      final List<dynamic> response = await _client
          .from('investimentos')
          .select()
          .eq('utilizador_id', utilizadorId);

      if (response.isNotEmpty) {
        List<Investimento> investimentos = List<Investimento>.from(
          response.map((x) => Investimento.fromJson(x))
        );
        return right(investimentos);
      } else {
        return left('Nenhum dado encontrado');
      }
    } catch (e) {
      return left('Erro ao carregar investimentos: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> adicionarInvestimento(Investimento investimento) async {
    try {
      // 1º passo -> Inserir o investimento
      await _client
          .from('investimentos')
          .insert(investimento.toJson())
          .select()
          .single();

      // 2º passo -> subtrair o valor do saldo
      final updateResponse = await atualizarSaldo(investimento.utilizadorId, investimento.valor, false);
      return updateResponse;
    } catch (e) {
      return left('Erro ao adicionar investimento: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> removerInvestimento(String investimentoId) async {
    try {
      // 1º passo -> Inserir o investimento
      final responseInvestimento = await _client
          .from('investimentos')
          .select('valor, utilizador_id')
          .eq('id', investimentoId)
          .single();

      // 2º passo -> remover o investimento
      await _client
          .from('investimentos')
          .delete()
          .eq('id', investimentoId)
          .select()
          .single();

      // 3º passo -> adicionar o valor ao saldo
      final updateResponse = await atualizarSaldo(responseInvestimento['utilizador_id'], responseInvestimento['valor'], true);
      return updateResponse;
    } catch (e) {
      return left('Erro ao remover investimento: ${e.toString()}');
    }
  }

Future<Either<String, bool>> atualizarSaldo(String utilizadorId, double valor, bool adicionar) async {
  try {
    await _client.rpc('atualizar_saldo', params: {
      'p_utilizador_id': utilizadorId,
      'p_valor': adicionar ? valor : -valor,
    });
   
    return right(true);
  } catch (e) {
    return left('Erro ao atualizar saldo: ${e.toString()}');
  }
}

}
