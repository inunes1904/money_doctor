class Transacao {
  final String id;
  final String utilizadorId;
  final String saldoId;
  final double valor;
  final String descricao;
  final DateTime dataTransacao;

  Transacao({
    required this.id,
    required this.utilizadorId,
    required this.saldoId,
    required this.valor,
    required this.descricao,
    required this.dataTransacao,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) => Transacao(
        id: json["id"],
        utilizadorId: json["utilizador_id"],
        saldoId: json["saldo_id"],
        valor: json["valor"].toDouble(),
        descricao: json["descricao"],
        dataTransacao: DateTime.parse(json["data_transacao"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "utilizador_id": utilizadorId,
        "saldo_id": saldoId,
        "valor": valor,
        "descricao": descricao,
        "data_transacao": dataTransacao.toIso8601String(),
      };
}
