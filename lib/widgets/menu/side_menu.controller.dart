import 'package:get/get.dart';

import '../../models/menu/side_menu_model.dart';
import '../../repository/authentication.repository.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';
import 'side_menu_data.dart';

class SideMenuController extends GetxController {
  final storageService = StorageService();
  List<MenuOptions> menuOptionsAvailable = <MenuOptions>[].obs;
  final StorageService _storage = StorageService();
  String? storedUserId;

  @override
  Future<void> onInit() async {
    super.onInit();
    storedUserId = await _storage.readSecureData("userId");

    // se storedUserId != null, o utilizador da aplicação está logado
    if (storedUserId != null) {
      menuOptionsAvailable = menuOptions
          .where((element) => element.showAfterLogin == true)
          .toList();
    } else {
      // caso storedUserId seja nulo, utilizador não está logado e só tem acesso a conteúdo que não necessite de login
      menuOptionsAvailable =
          menuOptions.where((element) => element.needLogin == false).toList();
    }
    update();
  }
}

void menuChoosenOption(String optionChoosen) async {
  final AuthenticationRepository authService = AuthenticationRepository();

  if (optionChoosen == "/logout") {
    authService.logout();
    Get.offAllNamed(AppRoutes.login);
  } else if (optionChoosen == "/registo") {
    Get.toNamed(optionChoosen);
  } else {
    Get.offNamed(optionChoosen);
  }
}
