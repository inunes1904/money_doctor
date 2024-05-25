import 'package:get/get.dart';
import 'package:moneydoctor/models/categorias/categorias.dart';
import '../../../services/storage_service.dart';
import 'categorias_relatorio_data.dart';

class RelatoriosController extends GetxController {
  final StorageService _storage = StorageService();
  final List<Categorias> opcoesRelatorio = categoriasRelatorioList;
  RxBool isLoading = RxBool(true);
  RxString storedUserId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    storedUserId.value = await _storage.readSecureData("userId") ?? "";
  }
}
