import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/header/header.dart';
import '../../../widgets/menu/side_menu.page.dart';
import 'relatorios.controller.dart';

class RelatoriosPage extends GetView<RelatoriosController> {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBarPublic(),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Column(
              children: [
                Text('Relatórios e Análises',
                    style: Theme.of(context).textTheme.titleLarge!),
                const SizedBox(
                  height: 20,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.opcoesRelatorio.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: deviceInfo.size.width > 700
                        ? (deviceInfo.size.width > 1060 ? 6 : 4)
                        : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        // Só navega se tiver link
                        controller.opcoesRelatorio[index].link != ""
                            ? Get.toNamed(
                                controller.opcoesRelatorio[index].link)
                            : null;
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 100,
                                child: Image.asset(
                                  controller.opcoesRelatorio[index].imagem,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                controller.opcoesRelatorio[index].titulo,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
