import '../../../models/categorias/categorias.dart';

final List<Categorias> categoriasRelatorioList = [
  Categorias(
    titulo: "Despesas Mensais",
    imagem: "assets/images/categorias/relatorios/despesasmensais.png",
    descricao: "Veja as suas despesas mensais em detalhe.",
    link: "/despesasMensais",
  ),
  Categorias(
    titulo: "Despesas vs Receitas",
    imagem: "assets/images/categorias/relatorios/despesasvsreceitas.png",
    descricao: "Analise as suas despesas em contraste com as receitas.",
    link: "/despesasVsReceitas",
  ),
  Categorias(
    titulo: "Análise de Investimentos",
    imagem: "assets/images/categorias/relatorios/analiseinvestimentos.png",
    descricao: "Analise todos os seus investimentos.",
    link: "/analiseInvestimentos",
  ),
];
