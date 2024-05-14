import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneydoctor/widgets/menu/side_menu.page.dart';
import 'package:shimmer/shimmer.dart';
import '../../styles/global.colors.dart';
import '../../widgets/header/header.dart';
import 'home.controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBarPublic(),
        drawer: const SideMenu(),
        body: Obx(() {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Olá ${controller.storedUsername}! Aceda a uma das Categorias",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (controller.isLoading.value)
                    // Enquanto carrega
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: deviceInfo.size.width > 700
                              ? (deviceInfo.size.width > 1060 ? 6 : 4)
                              : 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (ctx, index) {
                          return Card(
                            child: SizedBox(
                              height: 180,
                              child: Shimmer.fromColors(
                                  baseColor: GlobalColors.lightGrey,
                                  highlightColor: GlobalColors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 100,
                                          color: GlobalColors.lightGrey,
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 10,
                                          color: GlobalColors.lightGrey,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        },
                      ),
                    )
                  else // Depois de carregar conteúdo
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: controller.opcoesMoneyApp.length,
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
                              Get.toNamed(
                                  controller.opcoesMoneyApp[index].link);
                            },
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: Image.asset(controller
                                        .opcoesMoneyApp[index].imagem),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    controller.opcoesMoneyApp[index].titulo,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                ],
              ),
            ),
          );
        }));
  }
}
