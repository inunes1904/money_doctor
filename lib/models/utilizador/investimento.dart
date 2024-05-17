class Investimento {
  final String id;
  final String utilizadorId;
  final String tipo;
  final double valor;
  final DateTime? dataInvestimento;
  final String descricao;

  Investimento({
    required this.id,
    required this.utilizadorId,
    required this.tipo,
    required this.valor,
    this.dataInvestimento,
    required this.descricao,
  });

  factory Investimento.fromJson(Map<String, dynamic> json) => Investimento(
    id: json["id"],
    utilizadorId: json["utilizador_id"],
    tipo: json["tipo"],
    valor: json["valor"].toDouble(),
    dataInvestimento: json["data_investimento"] != null ? DateTime.parse(json["data_investimento"]) : null,
    descricao: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "utilizador_id": utilizadorId,
    "tipo": tipo,
    "valor": valor,
    "data_investimento": dataInvestimento?.toIso8601String(),
    "descricao": descricao,
  };
}
