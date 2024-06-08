import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';

import '../models/storage_item.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

abstract class AuthenticationInterface {
  Future<Either<String, bool>> login(
      {required String email, required String password});
  Future<void> logout();
  Future<bool> getToken();
  Future<Either<String, bool>> recuperarPassword({required String email});
  Future<Either<String, bool>> registarUtilizador(
      {required String email,
      required String password,
      required String nomeProprio,
      required String username});
}

class AuthenticationRepository implements AuthenticationInterface {
  final SupabaseClient _client = Supabase.instance.client;
  final StorageService _storage = StorageService();

  @override
  Future<bool> getToken() async {
    final token = await _storage.readSecureData("token");
    return token != null;
  }

  @override
  Future<Either<String, bool>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Método associado à BD -> Supabase
      final response = await _client.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.session != null && response.user != null) {
        // Guarda o token de acesso
        await _storage.writeSecureData(
            StorageItem("token", response.session!.accessToken));

        // Obter informações adicionais da tabela 'utilizadores'
        final userResponse = await _client
            .from('utilizadores')
            .select()
            .eq('id', response.user!.id)
            .single();

        if (userResponse.isEmpty) {
          return left("Erro ao obter dados do utilizador.");
        }

        final userData = userResponse;

        // Atualizar o campo 'ultimo_acesso'
        await _client
            .from('utilizadores')
            .update({'ultimo_acesso': DateTime.now().toIso8601String()}).eq(
                'id', response.user!.id);

        // Guarda os dados no armazenamento seguro (local)
        await _storage
            .writeSecureData(StorageItem("emailUtilizador", userData['email']));
        await _storage.writeSecureData(
            StorageItem("nomeProprio", userData['nome_proprio']));
        await _storage
            .writeSecureData(StorageItem("username", userData['username']));
        await _storage.writeSecureData(StorageItem("userId", userData['id']));

        return right(true);
      } else {
        return left("Erro no login");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      await _storage.deleteAllSecureData();
      Get.offNamed(AppRoutes.login);
    } catch (e) {
      await _storage.deleteAllSecureData();
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  Future<Either<String, bool>> registarUtilizador({
    required String email,
    required String password,
    required String nomeProprio,
    required String username,
  }) async {
    try {
      // Cria a conta de utilizador com e-mail e senha
      final AuthResponse res =
          await _client.auth.signUp(email: email, password: password);

      // Verifica se a sessão foi criada com sucesso
      if (res.user != null) {
        // Armazena informações adicionais na tabela de utilizadores
        await _client.from('utilizadores').insert({
          'nome_proprio': nomeProprio,
          'email': email,
          'username': username,
          'id': res.user!.id,
        });

        return right(true);
      } else {
        return left("Erro no registo do usuário.");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> recuperarPassword(
      {required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<String?> verificaToken() async {
    // Obter o token da secure storage
    String? token = await _storage.readSecureData('token');

    if (token != null && token.isNotEmpty) {
      //verificar se já expirou o token
      bool isTokenExpired = JwtDecoder.isExpired(token);

      if (isTokenExpired) {
        //já expirou, ir buscar novo token
        AuthenticationRepository auth = AuthenticationRepository();
        if (await auth.getToken()) {
          token = await _storage.readSecureData('token');
        }
      }
    }
    return token;
  }
}
