class Utilizador {
  final String id;
  final String nomeProprio;
  final String username;
  final String email;
  final DateTime? ultimoAcesso;

  Utilizador({
    required this.id,
    required this.nomeProprio,
    required this.email,
    required this.username,
    this.ultimoAcesso,
  });

  factory Utilizador.fromJson(Map<String, dynamic> json) => Utilizador(
        id: json["id"],
        nomeProprio: json["nome_proprio"],
        email: json["email"],
        username: json["username"],
        ultimoAcesso: json["ultimo_acesso"] != null
            ? DateTime.parse(json["ultimo_acesso"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome_proprio": nomeProprio,
        "email": email,
        "username": username,
        "ultimo_acesso":
            ultimoAcesso != null ? ultimoAcesso!.toIso8601String() : null,
      };
}
