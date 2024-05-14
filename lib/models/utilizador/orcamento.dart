import 'orcamento_item.dart';

class Orcamento {
  final String id;
  final String utilizadorId;
  final String categoria;
  final double valorPlaneado;
  final DateTime dataOrcamento;
  final String descricao;
  final List<ItemOrcamento> itens;

  Orcamento({
    required this.id,
    required this.utilizadorId,
    required this.categoria,
    required this.valorPlaneado,
    required this.dataOrcamento,
    required this.descricao,
    this.itens = const [],
  });

  factory Orcamento.fromJson(Map<String, dynamic> json) => Orcamento(
        id: json["id"],
        utilizadorId: json["utilizador_id"],
        categoria: json["categoria"],
        valorPlaneado: json["valor_planeado"].toDouble(),
        dataOrcamento: DateTime.parse(json["data_orcamento"]),
        descricao: json["descricao"],
        itens: (json["itens_orcamento"] as List<dynamic>?)
                ?.map((item) => ItemOrcamento.fromJson(item))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "utilizador_id": utilizadorId,
        "categoria": categoria,
        "valor_planeado": valorPlaneado,
        "data_orcamento": dataOrcamento.toIso8601String(),
        "descricao": descricao,
      };
}
