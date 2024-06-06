import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/utilizador/evento.dart';
import '../models/utilizador/evento_transacao.dart';
import '../models/utilizador/evento_utilizador.dart';
import '../models/utilizador/utilizador.dart';

class EventoRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Either<String, List<Evento>>> carregarEventos(
      String utilizadorId) async {
    try {
      final response =
          await _client.from('eventos').select().eq('criador_id', utilizadorId);

      final List<Evento> eventos =
          (response as List).map((e) => Evento.fromJson(e)).toList();

      return right(eventos);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> criarEvento(
      String nome, String descricao, String criadorId, bool ativo) async {
    try {
      final responseEvento = await _client
          .from('eventos')
          .insert({
            'nome': nome,
            'descricao': descricao,
            'criador_id': criadorId,
            'status': ativo,
          })
          .select()
          .single();

      final eventoId = responseEvento['id'];

      await _client.from('participantes_evento').insert({
        'evento_id': eventoId,
        'utilizador_id': criadorId,
        'convite_aceite': true,
        'saldado': false,
      });

      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<TransacaoPartilha>>> carregarTransacoesPartilha(
      String eventoId) async {
    try {
      final response = await _client
          .from('transacoes_evento')
          .select()
          .eq('evento_id', eventoId);

      final List<TransacaoPartilha> transacoes =
          (response as List).map((e) => TransacaoPartilha.fromJson(e)).toList();

      return right(transacoes);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<UtilizadorPartilha>>> carregarUtilizadoresPartilha(
      String eventoId) async {
    try {
      final response = await _client
          .from('participantes_evento')
          .select('*, utilizadores!inner(*), saldado')
          .eq('evento_id', eventoId);

      final List<UtilizadorPartilha> utilizadores = (response as List)
          .map((e) => UtilizadorPartilha(
                id: e['utilizadores']['id'],
                username: e['utilizadores']['username'],
                valorContribuido: e['valor_contribuido'] ?? 0,
                saldado: e['saldado'] ?? false,
              ))
          .toList();

      return right(utilizadores);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> adicionarUtilizadorPartilhaEvento(
      String eventoId, String userId) async {
    try {
      await _client.from('participantes_evento').insert({
        'evento_id': eventoId,
        'utilizador_id': userId,
        'convite_aceite': false,
        'saldado': false,
      });

      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<Utilizador>>> carregarTodosUtilizadores() async {
    try {
      final response = await _client.from('utilizadores').select();

      final List<Utilizador> utilizadores =
          (response as List).map((e) => Utilizador.fromJson(e)).toList();

      return right(utilizadores);
    } catch (e) {
      return left(e.toString());
    }
  }

// ainda não foi criado na view
  Future<Either<String, bool>> editarNomePartilhaEvento(
      String eventoId, String novoNome) async {
    try {
      final response = await _client
          .from('eventos')
          .update({'nome': novoNome}).eq('id', eventoId);

      if (response.error != null) {
        return left(response.error!.message);
      }

      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> adicionarDespesa(String eventoId,
      String utilizadorId, double valor, String descricao, bool pago) async {
    try {
      await _client.from('transacoes_evento').insert({
        'evento_id': eventoId,
        'utilizador_id': utilizadorId,
        'valor': valor,
        'descricao': descricao,
        'pago': pago,
      });

      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> alterarStatusEvento(
      String eventoId, bool status) async {
    try {
      await _client
          .from('eventos')
          .update({'status': status}).eq('id', eventoId);

      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> atualizarSaldado(String utilizadorId, String eventoId, bool saldado) async {
    try {
      await _client
          .from('participantes_evento')
          .update({'saldado': saldado})
          .eq('evento_id', eventoId)
          .eq('utilizador_id', utilizadorId);

      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }
}
