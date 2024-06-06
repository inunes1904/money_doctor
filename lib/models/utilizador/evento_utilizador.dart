class UtilizadorPartilha {
  final String id;
  final String username;
  final double valorContribuido;
  bool saldado;

  UtilizadorPartilha({
    required this.id,
    required this.username,
    required this.valorContribuido,
    required this.saldado
  });

  factory UtilizadorPartilha.fromJson(Map<String, dynamic> json) => UtilizadorPartilha(
        id: json["id"],
        username: json["username"],
        valorContribuido: json["valor_contribuido"].toDouble(),
        saldado: json["saldado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "valor_contribuido": valorContribuido,
        "saldado": saldado,
      };
}
