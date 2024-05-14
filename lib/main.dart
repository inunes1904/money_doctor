import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'routes/app_pages.dart';
import 'styles/theme.dart';
import 'utils/dependency.injection.dart';
import 'views/splash/splash.page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ligação à BD Supabase
  await Supabase.initialize(
    url: 'https://dfgjjfmagfrecbaupnqg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmZ2pqZm1hZ2ZyZWNiYXVwbnFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQ0MjUxMDMsImV4cCI6MjAzMDAwMTEwM30.EozAkeVU45haToX4opXdHFfHJEqjgjtwlt-sMxdvivw',
  );
  // .ligação à BD Supabase
  
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

// Para desenvolvimento
  HttpOverrides.global = MyHttpOverrides();
// .Para desenvolvimento

  runApp(const MainApp());
  //injectar as dependencias globais
  DependencyInjection.init();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Doctor',
      theme: AppTheme.appTheme, // estilização do tema definido em styles/theme
      home: const SplashPage(), // pagina de entrada da aplicação
      getPages: AppPages.pages,
    );
  }
}

// Para desenvolvimento
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
// .Para desenvolvimento
