import 'package:moneydoctor/models/utilizador/investimento_historico.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import '../../../models/utilizador/investimento.dart';

class InvestimentoRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Either<String, List<Investimento>>> carregarInvestimentos(
      String utilizadorId) async {
    try {
      final List<dynamic> response = await _client
          .from('investimentos')
          .select()
          .eq('utilizador_id', utilizadorId);

      if (response.isNotEmpty) {
        List<Investimento> investimentos = List<Investimento>.from(
            response.map((x) => Investimento.fromJson(x)));
        
        // Filtra investimentos que não possuem data de retirada no histórico
        List<Investimento> investimentosAbertos = [];
        for (var investimento in investimentos) {
          final historicoResponse = await _client
              .from('historico_investimentos')
              .select()
              .eq('investimento_id', investimento.id)
              .order('data_investimento', ascending: false)
              .limit(1);

          if (historicoResponse.isNotEmpty) {
            final historico = HistoricoInvestimento.fromJson(historicoResponse[0]);
            if (historico.dataRetirada == null) {
              investimentosAbertos.add(investimento);
            }
          }
        }

        return right(investimentosAbertos);
      } else {
        return left('Nenhum dado encontrado');
      }
    } catch (e) {
      return left('Erro ao carregar investimentos: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> adicionarInvestimento(
      Investimento investimento) async {
    try {
      await _client
          .from('investimentos')
          .insert(investimento.toJson())
          .select()
          .single();

      final updateResponse = await atualizarSaldo(
          investimento.utilizadorId, investimento.valor, false);
      return updateResponse;
    } catch (e) {
      return left('Erro ao adicionar investimento: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> removerInvestimento(
      String investimentoId, double valorFinal) async {
    try {
      final responseInvestimento = await _client
          .from('investimentos')
          .select('valor, utilizador_id')
          .eq('id', investimentoId)
          .single();

      final updateResponse = await atualizarSaldo(
          responseInvestimento['utilizador_id'],
          valorFinal,
          true);
      return updateResponse;
    } catch (e) {
      return left('Erro ao remover investimento: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> atualizarSaldo(
      String utilizadorId, double valor, bool adicionar) async {
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

  Future<void> adicionarInvestimentoHistorico(
      HistoricoInvestimento historico) async {
    await _client.from('historico_investimentos').insert(historico.toJson());
  }

  Future<void> fecharInvestimentoHistorico({
    required String investimentoId,
    required double valorFinal,
    required DateTime dataRetirada,
  }) async {
    await _client.from('historico_investimentos').update({
      'valor_final': valorFinal,
      'data_retirada': dataRetirada.toIso8601String(),
    }).eq('investimento_id', investimentoId);
  }

  Future<void> atualizarValorFinalInvestimento({
    required String id,
    required double valorFinal,
  }) async {
    await _client.from('historico_investimentos').update({
      'valor_final': valorFinal,
    }).eq('investimento_id', id);
  }

Future<Either<String, HistoricoInvestimento>> obterHistoricoInvestimento(String investimentoId) async {
     try {
      final response = await _client
          .from('historico_investimentos')
          .select()
          .eq('investimento_id', investimentoId)
          .order('data_investimento', ascending: false)
          .limit(1)
          .single();
      
        final historico = HistoricoInvestimento.fromJson(response);
        return right(historico);
      
    } catch (e) {
      return left('Erro ao obter registo: ${e.toString()}');
    }
  }

  // Função para listar todos os investimentos de um utilizador
  Future<Either<String, List<Investimento>>> listarInvestimentos(
      String utilizadorId) async {
    try {
      final List<dynamic> response = await _client
          .from('investimentos')
          .select()
          .eq('utilizador_id', utilizadorId);

      if (response.isNotEmpty) {
        List<Investimento> investimentos = List<Investimento>.from(
            response.map((x) => Investimento.fromJson(x)));
        return right(investimentos);
      } else {
        return left('Nenhum investimento encontrado');
      }
    } catch (e) {
      return left('Erro ao listar investimentos: ${e.toString()}');
    }
  }
}
