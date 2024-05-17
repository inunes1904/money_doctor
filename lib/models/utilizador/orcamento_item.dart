class ItemOrcamento {
  final String id;
  final String orcamentoId;
  final String descricao;
  final double valor;

  ItemOrcamento({
    required this.id,
    required this.orcamentoId,
    required this.descricao,
    required this.valor,
  });

  factory ItemOrcamento.fromJson(Map<String, dynamic> json) => ItemOrcamento(
        id: json["id"],
        orcamentoId: json["orcamento_id"],
        descricao: json["descricao"],
        valor: json["valor"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orcamento_id": orcamentoId,
        "descricao": descricao,
        "valor": valor,
      };
}
