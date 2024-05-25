import 'package:get/get.dart';
import 'package:moneydoctor/views/recuperarpass/recuperarpass.binding.dart';
import 'package:moneydoctor/views/recuperarpass/recuperarpass.page.dart';
import 'package:moneydoctor/views/utilizador/relatorios/relatorios.binding.dart';
import 'package:moneydoctor/views/utilizador/relatorios/relatorios.page.dart';
import '../views/utilizador/investimento/investimentos.binding.dart';
import '../views/utilizador/investimento/investimentos.page.dart';
import '../views/utilizador/orcamento/orcamentos.binding.dart';
import '../views/utilizador/orcamento/orcamentos.page.dart';
import '../views/utilizador/perfil/dados_utilizador.binding.dart';
import '../views/utilizador/perfil/dados_utilizador.page.dart';
import '../views/utilizador/relatorios/analiseinvestimentos/analiseinvestimentos.binding.dart';
import '../views/utilizador/relatorios/analiseinvestimentos/analiseinvestimentos.page.dart';
import '../views/utilizador/relatorios/despesasmensais/despesasmensais.binding.dart';
import '../views/utilizador/relatorios/despesasmensais/despesasmensais.page.dart';
import '../views/utilizador/relatorios/despesasvsreceitas/despesasvsreceitas.binding.dart';
import '../views/utilizador/relatorios/despesasvsreceitas/despesasvsreceitas.page.dart';
import '../views/utilizador/resumoFinanceiro/resumoFinanceiro.binding.dart';
import '../views/utilizador/resumoFinanceiro/resumoFinanceiro.page.dart';
import '../views/utilizador/visaoGeralSaldo/visaoGeralSaldo.binding.dart';
import '../views/utilizador/visaoGeralSaldo/visaoGeralSaldo.page.dart';
import '../views/home/home.binding.dart';
import '../views/home/home.page.dart';
import '../views/login/login.binding.dart';
import '../views/login/login.page.dart';
import '../views/registo/registo.binding.dart';
import '../views/registo/registo.page.dart';
import '../views/splash/splash.binding.dart';
import '../views/splash/splash.page.dart';
import '../views/suporte/suporte.binding.dart';
import '../views/suporte/suporte.page.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.recuperarpass,
      page: () => const RecuperarPassPage(),
      binding: RecuperarPassBinding(),
    ),
    GetPage(
      name: AppRoutes.registo,
      page: () => const RegistoPage(),
      binding: RegistoBinding(),
    ),
    GetPage(
      name: AppRoutes.dadosUtilizador,
      page: () => const DadosUtilizadorPage(),
      binding: DadosUtilizadorBinding(),
    ),
    GetPage(
      name: AppRoutes.visaoGeralSaldo,
      page: () => const VisaoGeralSaldoPage(),
      binding: VisaoGeralSaldoBinding(),
    ),
    GetPage(
      name: AppRoutes.resumoFinanceiro,
      page: () => const ResumoFinanceiroPage(),
      binding: ResumoFinanceiroBinding(),
    ),
    GetPage(
      name: AppRoutes.investimentos,
      page: () => const InvestimentosPage(),
      binding: InvestimentosBinding(),
    ),
    GetPage(
      name: AppRoutes.orcamentos,
      page: () => const OrcamentosPage(),
      binding: OrcamentosBinding(),
    ),
    GetPage(
      name: AppRoutes.relatorios,
      page: () => const RelatoriosPage(),
      binding: RelatoriosBinding(),
    ),
    GetPage(
      name: AppRoutes.despesasMensais,
      page: () => const DespesasMensaisPage(),
      binding: DespesasMensaisBinding(),
    ),
    GetPage(
      name: AppRoutes.despesasVsReceitas,
      page: () => const DespesasVsReceitasPage(),
      binding: DespesasVsReceitasBinding(),
    ),
    GetPage(
      name: AppRoutes.analiseInvestimentos,
      page: () => const AnaliseInvestimentosPage(),
      binding: AnaliseInvestimentosBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.despesasPartilhadas,
    //   page: () => const DespesasPartilhadasPage(),
    //   binding: DespesasPartilhadasBinding(),
    // ),
    GetPage(
      name: AppRoutes.suporte,
      page: () => const SuportePage(),
      binding: SuporteBinding(),
    ),
  ];
}
