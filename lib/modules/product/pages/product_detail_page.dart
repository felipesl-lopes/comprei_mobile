import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/utils/flushbar_helper.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/core/widgets/badgee.dart';
import 'package:appshop/core/widgets/image_fallback_icon.dart';
import 'package:appshop/core/widgets/send_button.dart';
import 'package:appshop/modules/avaliacao/enum/scale_size.dart';
import 'package:appshop/modules/avaliacao/providers/avaliacao_provider.dart';
import 'package:appshop/modules/avaliacao/widgets/avaliacao_list.dart';
import 'package:appshop/modules/avaliacao/widgets/rating_bar_widget.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/categorias/providers/categorias_provider.dart';
import 'package:appshop/modules/product/functions/adicionarproduto.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:appshop/modules/product/widgets/carousel_images_product.dart';
import 'package:appshop/modules/product/widgets/discount_badge.dart';
import 'package:appshop/modules/product/widgets/product_grid.dart';
import 'package:appshop/modules/product/widgets/promotion_countdown_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel? product;

  ProductDetailPage({this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late AvaliacaoProvider _avaliacaoProvider;
  ProductModel? _productFromRouteOrProvider(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ProductModel) return args;
    if (args is String) {
      final list =
          Provider.of<ProductProvider>(context, listen: false).produtos;
      try {
        return list.firstWhere((p) => p.id == args);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;
    _loaded = true;

    final product = widget.product ?? _productFromRouteOrProvider(context);

    if (product != null) {
      _avaliacaoProvider =
          Provider.of<AvaliacaoProvider>(context, listen: false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _avaliacaoProvider.carregarAvaliacoesPorProduto(product.id!);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final product = widget.product ?? _productFromRouteOrProvider(context);

        if (product?.id != null) {
          context.read<ProductProvider>().guardarProdutoPesquisado(
                product!.id!,
              );
        }

        context.read<ProductProvider>().loadResearchedProductsCommand.execute();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final initialProduct =
        widget.product ?? _productFromRouteOrProvider(context);

    if (initialProduct == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Produto'),
          backgroundColor: colorScheme.primary,
        ),
        body: Center(
          child: Text('Produto não encontrado.',
              style: TextStyle(color: colorScheme.onSurface)),
        ),
      );
    }

    final productList = Provider.of<ProductProvider>(context);

    ProductModel product;

    try {
      product =
          productList.produtos.firstWhere((p) => p.id == initialProduct.id);
    } catch (_) {
      product = initialProduct;
    }

    late int unidadesArredondadas;

    if (product.quantity >= 100) {
      unidadesArredondadas = (product.quantity / 100).floor() * 100;
    } else if (product.quantity >= 10) {
      unidadesArredondadas = (product.quantity / 10).floor() * 10;
    } else {
      unidadesArredondadas = product.quantity;
    }

    final cart = Provider.of<CartProvider>(context);

    final _categories = Provider.of<CategoriasProvider>(context, listen: false);

    final List<String> _nomesCategorias =
        _categories.getNomesCategorias(product.categories);

    final List<ProductModel> _produtosDaCategoria =
        Provider.of<ProductProvider>(context)
            .produtos
            .where((produto) =>
                produto.id != product.id &&
                produto.categories
                    .any((categoria) => product.categories.contains(categoria)))
            .toList();

    Future<void> handleBuy() async {
      try {
        await cart.adcItemAoCarrinho(product);
      } catch (_) {
      } finally {
        Navigator.of(context).pushNamed(AppRoutes.CART);
      }
    }

    Future<void> toggleFavorite() async {
      try {
        await productList.adicionarOuRemoverFavorito(product.id!);
      } catch (e) {
        showAppFlushbar(context,
            message: e.toString().replaceAll('Exception:', ''),
            type: FlushType.error);
      }
    }

    return Scaffold(
      appBar: BackAppBar(
        title: "Informações do produto",
        actions: [
          Consumer<CartProvider>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CART),
                icon: Icon(Icons.shopping_cart, color: colorScheme.onPrimary)),
            builder: (ctx, cart, child) => Badgee(
              value: cart.totalDeItens.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 22),
                  Stack(
                    children: [
                      product.imageUrls.isNotEmpty
                          ? CarouselImagesProduct(product.imageUrls)
                          : AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                child: ImageFallbackIcon(size: 120),
                              ),
                            ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: colorScheme.surface.withOpacity(0.4),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(60),
                              onTap: () async => toggleFavorite(),
                              splashColor: colorScheme.error.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                    product.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: product.isFavorite
                                        ? colorScheme.error
                                        : colorScheme.onSurface),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (product.isPromotional)
                    DiscountBadge(
                      percentage: product.discountPercentage!,
                      fontSize: 15,
                    ),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (product.isPromotional)
                    Text(
                      formatPrice(
                        product.price,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: colorScheme.onSurface.withOpacity(0.5),
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  Text(
                    formatPrice(
                      product.valorFinalDoProduto(),
                    ),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface),
                  ),
                  PromotionCountdownText(
                    isPromotional: product.isPromotional,
                    promotionEndDate: product.promotionEndDate,
                  ),
                  RatingBarWidget(
                    scaleSize: ScaleSize.medium,
                    notaMedia: product.notaMedia,
                    totalAvaliacoes: product.totalAvaliacoes,
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _nomesCategorias.length > 1
                                ? "Categorias: "
                                : "Categoria: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            _nomesCategorias.join(', '),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text("Descrição:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface)),
                      Text(product.description,
                          style: TextStyle(color: colorScheme.onSurface)),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: product.quantity <= 0
                            ? Container(
                                decoration: BoxDecoration(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text('Produto indisponível'))
                            : Text(
                                unidadesArredondadas < product.quantity
                                    ? 'Unidades disponíveis: + de $unidadesArredondadas'
                                    : 'Unidades disponíveis: ${product.quantity}',
                                style: TextStyle(
                                    fontSize: 15, color: colorScheme.onSurface),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  AvaliacaoList(
                    productId: product.id!,
                    productName: product.name,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: SendButton(
                      "Comprar agora",
                      product.quantity <= 0 ? null : handleBuy,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: SendButton(
                      'Adicionar ao carrinho',
                      product.quantity <= 0
                          ? null
                          : () => ProductMethod.adicionarProdutoAoCarrinho(
                                cart: cart,
                                context: context,
                                product: product,
                              ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            if (_produtosDaCategoria.isNotEmpty)
              ProductGrid(
                list_products: _produtosDaCategoria,
                quantityGrid: 4,
                gridHorizontal: true,
                title: "Produtos da mesma categoria",
              ),
          ],
        ),
      ),
    );
  }
}
