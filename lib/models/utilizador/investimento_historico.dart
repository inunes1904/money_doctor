class HistoricoInvestimento {
  final String id;
  final String investimentoId;
  final String usuarioId;
  final String tipo;
  final double valorInicial;
  final DateTime dataInvestimento;
  final String descricao;
  final double? valorFinal;
  final DateTime? dataRetirada;

  HistoricoInvestimento({
    required this.id,
    required this.investimentoId,
    required this.usuarioId,
    required this.tipo,
    required this.valorInicial,
    required this.dataInvestimento,
    required this.descricao,
    this.valorFinal,
    this.dataRetirada,
  });

  factory HistoricoInvestimento.fromJson(Map<String, dynamic> json) => HistoricoInvestimento(
        id: json["id"],
        investimentoId: json["investimento_id"],
        usuarioId: json["usuario_id"],
        tipo: json["tipo"],
        valorInicial: json["valor_inicial"].toDouble(),
        dataInvestimento: DateTime.parse(json["data_investimento"]),
        descricao: json["descricao"],
        valorFinal: json["valor_final"] != null ? json["valor_final"].toDouble() : null,
        dataRetirada: json["data_retirada"] != null ? DateTime.parse(json["data_retirada"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "investimento_id": investimentoId,
        "usuario_id": usuarioId,
        "tipo": tipo,
        "valor_inicial": valorInicial,
        "data_investimento": dataInvestimento.toIso8601String(),
        "descricao": descricao,
        "valor_final": valorFinal,
        "data_retirada": dataRetirada?.toIso8601String(),
      };
}
