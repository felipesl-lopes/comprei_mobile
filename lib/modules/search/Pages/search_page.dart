import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/widgets/badgee.dart';
import 'package:appshop/core/widgets/drawer_app_bar.dart';
import 'package:appshop/core/widgets/feedback_message.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:appshop/modules/product/widgets/product_grid.dart';
import 'package:appshop/modules/search/models/search_model.dart';
import 'package:appshop/modules/search/pages/modal_filtro_produto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductModel> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasSearched = false;

  final ScrollController _scrollController = ScrollController();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _visibleProducts = [];
  int _currentLimit = 10;

  bool _isInit = true;
  String? _initialQuery;
  String? _initialCategoryId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is SearchPageArgs) {
        if (args.query != null && args.query!.trim().isNotEmpty) {
          _searchController.text = args.query!;
          _initialQuery = args.query!.trim();
        }
        if (args.categoryId != null && args.categoryId!.isNotEmpty) {
          _initialCategoryId = args.categoryId;
        }
      }
      _isInit = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_paginationListener);

    Provider.of<ProductProvider>(context, listen: false)
        .loadProductsCommand
        .execute()
        .then((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      if (_initialCategoryId != null) {
        _filteredProducts = provider.produtosPorCategoria(_initialCategoryId!);
        _hasSearched = true;
      } else if (_initialQuery != null) {
        _filteredProducts = provider.searchByName(_initialQuery!);
        _hasSearched = true;
      }

      final products = _hasSearched ? _filteredProducts : provider.produtos;

      _allProducts = products;
      _visibleProducts = _allProducts.take(_currentLimit).toList();

      setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _paginationListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_visibleProducts.length >= _allProducts.length) return;

    setState(() {
      _currentLimit += 10;
      _visibleProducts = _allProducts.take(_currentLimit).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    final productsToShow = _visibleProducts;

    void _searchProduct() {
      final query = _searchController.text.trim();
      if (query.isEmpty) return;

      setState(() {
        _hasSearched = true;
        _filteredProducts = provider.searchByName(query);
        _allProducts = _filteredProducts;
        _currentLimit = 10;
        _visibleProducts = _allProducts.take(_currentLimit).toList();
      });

      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      appBar: DrawerAppBar(
        titleWidget: TextField(
          controller: _searchController,
          autofocus: false,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            fillColor: colorScheme.onPrimary,
            filled: true,
            hintText: "Buscar produto",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
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
          IconButton(
            onPressed: () => modalFiltroProduto(context: context),
            icon: Icon(
              Icons.tune,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Consumer<CartProvider>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CART),
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
            builder: (ctx, cart, child) => Badgee(
              value: cart.totalDeItens.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : provider.loadProductsCommand.value.isFailure
              ? Center(
                  child: FeedbackMessage(
                  message: "Não foi possível carregar os produtos.",
                  icon: Icons.error_outline,
                  iconColor: colorScheme.error,
                ))
              : Column(
                  children: [
                    if (_searchController.text.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Exibindo resultado de pesquisa para: ${_searchController.text}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    productsToShow.isEmpty
                        ? Expanded(
                            child: Center(
                              child: FeedbackMessage(
                                  message: "Nenhum produto encontrado.",
                                  icon: Icons.search_off),
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: ProductGrid(
                                list_products: productsToShow,
                                title: "Produtos para você",
                              ),
                            ),
                          ),
                  ],
                ),
    );
  }
}
