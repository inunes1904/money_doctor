import 'package:get/get.dart';
import 'package:moneydoctor/views/suporte/faq_data.dart';

class SuporteController extends GetxController {
  final String emailSuporte = 'suporte@moneydoctor.xpto';
  final RxList<Map<String, String>> faqs =
      RxList<Map<String, String>>(faqsData);

  @override
  void onInit() {
    super.onInit();
  }
}
