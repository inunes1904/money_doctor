import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import '../models/utilizador/saldo.dart';

class SaldoRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Either<String, List<Saldo>>> carregarSaldos(
      String utilizadorId) async {
    try {
      final response = await _client
          .from('saldos')
          .select('*, transacoes(*)')
          .eq('utilizador_id', utilizadorId)
          .maybeSingle();

      if (response == null) {
        return left('Nenhum saldo encontrado');
      } else {
        List<Saldo> saldos = List<Saldo>.from([Saldo.fromJson(response)]);
        return right(saldos);
      }
    } catch (e) {
      return left('Erro ao carregar saldos: ${e.toString()}');
    }
  }

  Future<Either<String, bool>> atualizarSaldo(String utilizadorId, double valor,
      bool adicionar, String descricao) async {
    try {
      final response = await _client
          .from('saldos')
          .select()
          .eq('utilizador_id', utilizadorId)
          .maybeSingle();

      if (response == null) {
        // Criar novo saldo se não existir
        double novoSaldo = adicionar ? valor : 0.0;
        final saldoResponse = await _client
            .from('saldos')
            .insert({
              'utilizador_id': utilizadorId,
              'saldo': novoSaldo,
              'data_atualizacao': DateTime.now().toIso8601String(),
            })
            .select()
            .single();
        final saldoId = saldoResponse['id'];

        // Adicionar transação
        await _client.from('transacoes').insert({
          'utilizador_id': utilizadorId,
          'saldo_id': saldoId,
          'valor': adicionar ? valor : -valor,
          'descricao': descricao,
          'data_transacao': DateTime.now().toIso8601String(),
        });

        return right(true);
      } else {
        // Atualizar saldo existente
        double saldoAtual = response['saldo'];
        double novoSaldo = saldoAtual + (adicionar ? valor : -valor);
        final saldoId = response['id'];

        await _client.from('saldos').update({
          'saldo': novoSaldo,
          'data_atualizacao': DateTime.now().toIso8601String()
        }).eq('utilizador_id', utilizadorId);

        // Adicionar transação
        await _client.from('transacoes').insert({
          'utilizador_id': utilizadorId,
          'saldo_id': saldoId,
          'valor': adicionar ? valor : -valor,
          'descricao': descricao,
          'data_transacao': DateTime.now().toIso8601String(),
        });

        return right(true);
      }
    } catch (e) {
      return left('Erro ao atualizar saldo: ${e.toString()}');
    }
  }
}
