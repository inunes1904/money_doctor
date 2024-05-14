import 'saldo_transacao.dart';

class Saldo {
  final String id;
  final String utilizadorId;
  final double saldo;
  final DateTime dataAtualizacao;
  final List<Transacao> transacoes;

  Saldo({
    required this.id,
    required this.utilizadorId,
    required this.saldo,
    required this.dataAtualizacao,
    this.transacoes = const [],
  });

  factory Saldo.fromJson(Map<String, dynamic> json) => Saldo(
        id: json["id"],
        utilizadorId: json["utilizador_id"],
        saldo: json["saldo"].toDouble(),
        dataAtualizacao: DateTime.parse(json["data_atualizacao"]),
        transacoes: (json["transacoes"] as List<dynamic>?)
                ?.map((item) => Transacao.fromJson(item))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "utilizador_id": utilizadorId,
        "saldo": saldo,
        "data_atualizacao": dataAtualizacao.toIso8601String(),
        "transacoes": transacoes.map((item) => item.toJson()).toList(),
      };
}
