import 'package:appshop/modules/auth/pages/auth_or_home_page.dart';
import 'package:appshop/modules/auth/pages/auth_page.dart';
import 'package:appshop/modules/avaliacao/pages/avaliacao_produto_page.dart';
import 'package:appshop/modules/avaliacao/pages/lista_avaliacoes_page.dart';
import 'package:appshop/modules/cart/pages/cart_page.dart';
import 'package:appshop/modules/compras/pages/compras_page.dart';
import 'package:appshop/modules/compras/pages/detalhes_da_compra_page.dart';
import 'package:appshop/modules/compras/pages/finalizar_compra_page.dart';
import 'package:appshop/modules/compras/pages/selecionar_endereco_page.dart';
import 'package:appshop/modules/endereco/pages/gerenciar_enderecos_page.dart';
import 'package:appshop/modules/endereco/pages/novo_endereco_page.dart';
import 'package:appshop/modules/home/pages/home_page.dart';
import 'package:appshop/modules/manage_products/pages/manage_product_form_page.dart';
import 'package:appshop/modules/manage_products/pages/manage_products_page.dart';
import 'package:appshop/modules/product/pages/product_detail_page.dart';
import 'package:appshop/modules/profile/pages/dados_usuario_page.dart';
import 'package:appshop/modules/profile/pages/profile_page.dart';
import 'package:appshop/modules/profile/preferencias/pages/preferencias_page.dart';
import 'package:appshop/modules/search/pages/search_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const AUTH_OR_HOME = "/";
  static const AUTH_LOGIN = "/login";
  static const HOME = "/home";
  static const DETAILS_PRODUCT = "/details-product";
  static const CART = "/cart";
  static const COMPRAS = "/compras";
  static const DETALHES_COMPRAS = '/detalhes-compras';
  static const MANAGE_PRODUCTS = "/manage-products";
  static const MANAGE_PRODUCT_FORM = "/manage-product-form";
  static const PROFILE = "/profile";
  static const SEARCH_PRODUCT = "/search-product";
  static const PROFILE_USER_DATA = '/user_data';
  static const PROFILE_SECURITY_ACCOUNT = '/security_account';
  static const SELECIONAR_ENDERECO = '/select_address';
  static const FINALIZE_PURCHASE = '/finalize_purchase';
  static const NOVO_ENDERECO = '/new';
  static const AVALIACAO_PRODUTO = '/avaliacao_produto';
  static const LISTA_AVALIACOES = '/lista_avaliacoes';
  static const GERENCIAR_ENDERECO = '/gerenciar_endereco';
  static const PREFERENCIAS = '/preferencias';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case AUTH_OR_HOME:
        page = AuthOrHomePage();
        break;

      case AUTH_LOGIN:
        page = AuthLogin();
        break;

      case HOME:
        page = HomePage();
        break;

      case DETAILS_PRODUCT:
        page = ProductDetailPage();
        break;

      case CART:
        page = CartPage();
        break;

      case COMPRAS:
        page = ComprasPage();
        break;

      case DETALHES_COMPRAS:
        page = DetalhesDaCompraPage();
        break;

      case MANAGE_PRODUCTS:
        page = ManageProductsPage();
        break;

      case MANAGE_PRODUCT_FORM:
        page = ProductFormPage();
        break;

      case PROFILE:
        page = ProfilePage();
        break;

      case SEARCH_PRODUCT:
        page = SearchPage();
        break;

      case PROFILE_USER_DATA:
        page = DadosUsuarioPage();
        break;

      case SELECIONAR_ENDERECO:
        page = SelecionarEnderecoPage();
        break;

      case FINALIZE_PURCHASE:
        page = FinalizarCompraPage();
        break;

      case NOVO_ENDERECO:
        page = NovoEnderecoPage();
        break;

      case AVALIACAO_PRODUTO:
        page = AvaliacaoProdutoPage();
        break;

      case LISTA_AVALIACOES:
        page = ListaAvaliacoesPage();
        break;

      case GERENCIAR_ENDERECO:
        page = GerenciarEnderecosPage();
        break;

      case PREFERENCIAS:
        page = PreferenciasPage();
        break;

      default:
        page = HomePage();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(
          CurveTween(curve: Curves.ease),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 480),
      reverseTransitionDuration: Duration(milliseconds: 480),
    );
  }
}
