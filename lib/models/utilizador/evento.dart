class Evento {
  final String id;
  final String nome;
  final String descricao;
  final String criadorId;
  final DateTime dataCriacao;
  bool status;

  Evento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.criadorId,
    required this.dataCriacao,
    required this.status,
  });

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
        id: json["id"],
        nome: json["nome"],
        descricao: json["descricao"],
        criadorId: json["criador_id"],
        dataCriacao: DateTime.parse(json["data_criacao"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "descricao": descricao,
        "criador_id": criadorId,
        "data_criacao": dataCriacao.toIso8601String(),
        "status": status,
      };
}
