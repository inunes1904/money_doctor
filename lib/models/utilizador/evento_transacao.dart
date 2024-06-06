class TransacaoPartilha {
  final String id;
  final String eventoId;
  final String utilizadorId;
  final double valor;
  final String descricao;
  final DateTime dataTransacao;
  final bool pago;

  TransacaoPartilha({
    required this.id,
    required this.eventoId,
    required this.utilizadorId,
    required this.valor,
    required this.descricao,
    required this.dataTransacao,
    required this.pago,
  });

  factory TransacaoPartilha.fromJson(Map<String, dynamic> json) => TransacaoPartilha(
    id: json["id"],
    eventoId: json["evento_id"],
    utilizadorId: json["utilizador_id"],
    valor: json["valor"].toDouble(),
    descricao: json["descricao"],
    dataTransacao: DateTime.parse(json["data_transacao"]),
    pago: json["pago"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "evento_id": eventoId,
    "utilizador_id": utilizadorId,
    "valor": valor,
    "descricao": descricao,
    "data_transacao": dataTransacao.toIso8601String(),
    "pago": pago,
  };
}
