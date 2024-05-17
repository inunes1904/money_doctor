import 'package:get/get.dart';

import '../../models/categorias/categorias.dart';
import '../../services/storage_service.dart';
import 'categorias_data.dart';

class HomeController extends GetxController {
  RxBool isLoading = RxBool(true);
  RxBool hasError = RxBool(false);
  // Pode depois ser passado para BD
  final List<Categorias> opcoesMoneyApp = categoriasList;
  final StorageService _storage = StorageService();
  RxString storedUsername = "Utilizador".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading = false.obs;
    storedUsername.value = await _storage.readSecureData("username") ?? "Utilizador";
  }
}
