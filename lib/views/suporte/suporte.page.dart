import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../styles/global.colors.dart';
import '../../widgets/header/header.dart';
import '../../widgets/menu/side_menu.page.dart';
import 'suporte.controller.dart';

class SuportePage extends GetView<SuporteController> {
  const SuportePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarPublic(),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Column(
              children: [
                Text(
                  'Suporte',
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: 10),
                Text(
                  'Para qualquer questão, entre em contacto:',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: 8),
                SelectableText(
                  controller.emailSuporte,
                  style:
                      const TextStyle(fontSize: 14, color: Colors.blueAccent),
                  onTap: () {
                    // função para abrir e-mail
                  },
                ),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "FAQs",
                        style: Theme.of(context).textTheme.headlineLarge!,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.faqs.length,
                        itemBuilder: (context, index) {
                          final faq = controller.faqs[index];
                          return ExpansionTile(
                            title: Text(faq['Questão']!),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(faq['Resposta']!),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
