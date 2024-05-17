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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Suporte',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Para qualquer questão, entre em contacto:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  controller.emailSuporte,
                  style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  onTap: () {
                    // função para abrir e-mail
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "FAQs",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
