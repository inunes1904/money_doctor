import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../styles/global.colors.dart';
import 'side_menu.controller.dart';

class SideMenu extends GetView<SideMenuController> {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context),
          buildMenuItems(context),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        color: GlobalColors.navbarColor,
        padding: EdgeInsets.only(
            top: 0 + MediaQuery.of(context).padding.top, bottom: 0),
        child: ListTile(
          title: Image.asset(
            'assets/images/logo.png',
            height: 75,
          ),
          onTap: () {
            menuChoosenOption(controller.storedUserId != null
                ? AppRoutes.home
                : AppRoutes.login);
          },
        ),
      );

  Widget buildMenuItems(BuildContext context) => Expanded(
        child: GetBuilder<SideMenuController>(
          init: SideMenuController(),
          builder: (controller) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: controller.menuOptionsAvailable.length,
              itemBuilder: (ctx, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: controller.menuOptionsAvailable[index].icon,
                      title: Text(
                        controller.menuOptionsAvailable[index].title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      onTap: () {
                        menuChoosenOption(
                            controller.menuOptionsAvailable[index].link);
                      },
                    ),
                    const Divider(height: 0),
                  ],
                );
              },
            );
          },
        ),
      );
}
