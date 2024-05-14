import 'package:flutter/material.dart';

import '../../models/menu/side_menu_model.dart';
import '../../routes/app_routes.dart';

final menuOptions = [
  MenuOptions(
    icon: const Icon(Icons.login, color: Colors.blue),
    title: 'Login',
    link: AppRoutes.login,
    needLogin: false,
    showAfterLogin: false,
  ),
  MenuOptions(
    icon: const Icon(Icons.person_add, color: Colors.green),
    title: 'Novo Registo',
    link: AppRoutes.registo,
    needLogin: false,
    showAfterLogin: false,
  ),
  MenuOptions(
    icon: const Icon(Icons.person, color: Colors.purple),
    title: 'Seu Perfil',
    link: AppRoutes.dadosUtilizador,
    needLogin: true,
    showAfterLogin: true,
  ),
  MenuOptions(
    icon: const Icon(Icons.account_balance_wallet, color: Colors.teal),
    title: 'Visão Geral do Saldo',
    link: AppRoutes.visaoGeralSaldo,
    needLogin: true,
    showAfterLogin: true,
  ),
  MenuOptions(
    icon: const Icon(Icons.analytics, color: Colors.orange),
    title: 'Resumo Financeiro',
    link: AppRoutes.resumoFinanceiro,
    needLogin: true,
    showAfterLogin: true,
  ),
  MenuOptions(
    icon: const Icon(Icons.show_chart, color: Colors.red),
    title: 'Investimentos',
    link: AppRoutes.investimentos,
    needLogin: true,
    showAfterLogin: true,
  ),
  MenuOptions(
    icon: const Icon(Icons.pie_chart, color: Colors.indigo),
    title: 'Orçamentos',
    link: AppRoutes.orcamentos,
    needLogin: true,
    showAfterLogin: true,
  ),
  MenuOptions(
    icon: const Icon(Icons.support_agent, color: Colors.cyan),
    title: 'Suporte',
    link: AppRoutes.suporte,
    needLogin: false,
    showAfterLogin: true,
  ),
  MenuOptions(
    icon: const Icon(Icons.logout, color: Colors.brown),
    title: 'Logout',
    link: '/logout',
    needLogin: true,
    showAfterLogin: true,
  ),
];
