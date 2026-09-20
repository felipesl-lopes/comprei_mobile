import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/widgets/app_drawer.dart';
import 'package:appshop/core/widgets/badgee.dart';
import 'package:appshop/core/widgets/drawer_app_bar.dart';
import 'package:appshop/core/widgets/feedback_message.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/categorias/providers/categorias_provider.dart';
import 'package:appshop/modules/endereco/providers/endereco_provider.dart';
import 'package:appshop/modules/home/providers/banners_provider.dart';
import 'package:appshop/modules/home/widgets/banner_carousel.dart';
import 'package:appshop/modules/home/widgets/card_incentivo_carrinho.dart';
import 'package:appshop/modules/home/widgets/category_roundels.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:appshop/modules/product/widgets/product_grid.dart';
import 'package:appshop/modules/profile/preferencias/providers/preferences_provider.dart';
import 'package:appshop/modules/search/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final productProvider = context.read<ProductProvider>();

    await productProvider.loadProductsCommand.execute();

    await Future.wait([
      productProvider.loadResearchedProductsCommand.execute(),
      context.read<CategoriasProvider>().loadCategoriesCommand.execute(),
      context.read<BannersProvider>().loadBannersCommand.execute(),
      context.read<CartProvider>().loadCartCommand.execute(),
      context.read<ProductProvider>().loadMyProductsCommand.execute(),
      context.read<ProductProvider>().loadFavoritesProductsCommand.execute(),
      context.read<EnderecoProvider>().loadAddressCommand.execute(),
      context.read<PreferencesProvider>().loadPreferencesCommand.execute(),
    ]);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchProduct() {
    final query = _searchController.text.trim();

    if (query.isEmpty) return;

    _searchController.clear();

    Navigator.of(context).pushNamed(
      AppRoutes.SEARCH_PRODUCT,
      arguments: SearchPageArgs(query: query),
    );
  }

  void _searchProductCategory(String categoryId) {
    Navigator.of(context).pushNamed(
      AppRoutes.SEARCH_PRODUCT,
      arguments: SearchPageArgs(categoryId: categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produtosProvider = context.watch<ProductProvider>();
    final bannersProvider = context.watch<BannersProvider>();
    final categoriasProvider = context.watch<CategoriasProvider>();
    final preferencesProvider = context.watch<PreferencesProvider>();

    final productsValue = produtosProvider.loadProductsCommand.value;
    final bannersValue = bannersProvider.loadBannersCommand.value;
    final categoriasValue = categoriasProvider.loadCategoriesCommand.value;
    final preferencesValue = preferencesProvider.loadPreferencesCommand.value;

    final isLoading = productsValue.isIdle ||
        productsValue.isRunning ||
        bannersValue.isIdle ||
        bannersValue.isRunning ||
        categoriasValue.isIdle ||
        categoriasValue.isRunning ||
        preferencesValue.isRunning ||
        preferencesValue.isIdle;

    final categorias = categoriasProvider.principaisCategorias.toList();
    final produtosEmOferta = produtosProvider.produtosEmOferta;

    return Scaffold(
      appBar: DrawerAppBar(
        titleWidget: TextField(
          controller: _searchController,
          autofocus: false,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,
            hintText: "Buscar produto",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            suffixIcon: IconButton(
              style: IconButton.styleFrom(
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              onPressed: _searchProduct,
              icon: Icon(Icons.search, size: 20),
            ),
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            builder: (ctx, cart, child) {
              return Badgee(
                value: cart.totalDeItens.toString(),
                child: child!,
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Theme.of(context).colorScheme.background,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BannerCarousel(
                        bannerList: bannersProvider.items,
                      ),
                      SizedBox(height: 12),
                      CategoryRoundels(
                        categorias: categorias,
                        onCategorySelected: _searchProductCategory,
                      ),
                      if (produtosProvider
                          .loadFavoritesProductsCommand.value.isFailure)
                        FeedbackMessage(
                          message:
                              "Não foi possível carregar seus produtos favoritos.",
                          icon: Icons.error_outline,
                          iconColor: Theme.of(context).colorScheme.error,
                        ),
                      if (produtosProvider.produtosFavoritos.isNotEmpty &&
                          preferencesProvider
                                  .preferences!.exibirProdutosFavoritos !=
                              false)
                        ProductGrid(
                          list_products: produtosProvider.produtosFavoritos,
                          quantityGrid: 4,
                          title: "Seus favoritos",
                          gridHorizontal: true,
                        ),
                      if (produtosProvider.loadProductsCommand.value.isSuccess)
                        CardIncentivoCarrinho(),
                      if (produtosProvider
                              .loadResearchedProductsCommand.value.isSuccess &&
                          preferencesProvider
                                  .preferences!.exibirProdutosVisualizados !=
                              false)
                        ProductGrid(
                          list_products: produtosProvider
                              .produtosVisualizados.reversed
                              .toList(),
                          quantityGrid: 5,
                          title: "Últimos vistos",
                          gridHorizontal: true,
                        ),
                      if (produtosProvider.loadProductsCommand.value.isFailure)
                        FeedbackMessage(
                          message: "Não foi possível carregar os produtos.",
                          icon: Icons.error_outline,
                          iconColor: Theme.of(context).colorScheme.error,
                        )
                      else if (produtosProvider.produtos.isEmpty)
                        FeedbackMessage(
                          message: "Nenhum produto encontrado.",
                          icon: Icons.inventory_2_outlined,
                        )
                      else
                        ProductGrid(
                          list_products: produtosProvider.produtos,
                          quantityGrid: 6,
                          title: "Produtos para você",
                        ),
                      SizedBox(height: 16),
                      if (produtosEmOferta.isNotEmpty)
                        ProductGrid(
                          list_products: produtosEmOferta,
                          quantityGrid: 6,
                          title: "Produtos em oferta",
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
