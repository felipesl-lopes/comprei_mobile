import 'package:appshop/modules/product/models/product_image_model.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:appshop/modules/product/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository;

  late final Command0<List<ProductModel>> loadProductsCommand;
  late final Command0<List<ProductModel>> loadMyProductsCommand;
  late final Command0<List<ProductModel>> loadFavoritesProductsCommand;
  late final Command0<List<ProductModel>> loadResearchedProductsCommand;

  List<ProductModel> _produtos = [];
  List<ProductModel> _meusProdutos = [];
  List<ProductModel> _produtosFavoritos = [];
  List<ProductModel> _produtosVisualizados = [];

  ProductProvider(
    this._productRepository,
  ) {
    loadProductsCommand = Command0(_loadProducts);
    loadMyProductsCommand = Command0(_loadMyProducts);
    loadFavoritesProductsCommand = Command0(_loadFavoritesProducts);
    loadResearchedProductsCommand = Command0(_loadResearchedProducts);
  }

  List<ProductModel> get produtos => [..._produtos];
  List<ProductModel> get meusProdutos => [..._meusProdutos];
  List<ProductModel> get produtosFavoritos => [..._produtosFavoritos];
  List<ProductModel> get produtosVisualizados => [..._produtosVisualizados];

  List<ProductModel> get produtosEmOferta =>
      _produtos.where((p) => p.isPromotional).toList();

  int get quantidadeDeProdutos {
    return _produtos.length;
  }

  void setProdutos(List<ProductModel> value) {
    _produtos = value;
    notifyListeners();
  }

  void setMeusProdutos(List<ProductModel> value) {
    _meusProdutos = value;
    notifyListeners();
  }

  void setProdutosFavoritos(List<ProductModel> value) {
    _produtosFavoritos = value;
    notifyListeners();
  }

  void setProdutosVisualizados(List<ProductModel> value) {
    _produtosVisualizados = value;
    notifyListeners();
  }

  void clear() {
    _meusProdutos.clear();
    _produtosFavoritos.clear();
  }

  /**
   * Método void que recebe os dados de avaliação do produto atualizado.
   * Necessita notificar seu proprio listener para escutar a alteração.
   */
  void atualizarAvaliacaoProduto({
    required String productId,
    required double notaMedia,
    required int totalAvaliacoes,
  }) {
    _atualizarProdutosNaLista(
      _produtos,
      productId,
      notaMedia,
      totalAvaliacoes,
    );

    _atualizarProdutosNaLista(
      _produtosFavoritos,
      productId,
      notaMedia,
      totalAvaliacoes,
    );

    notifyListeners();
  }

  void _atualizarProdutosNaLista(
    List<ProductModel> produtos,
    String productId,
    double notaMedia,
    int totalAvaliacoes,
  ) {
    final index = produtos.indexWhere((e) => e.id == productId);

    if (index == -1) return;

    produtos[index] = produtos[index].copyWith(
      notaMedia: notaMedia,
      totalAvaliacoes: totalAvaliacoes,
    );
  }

  Future<Result<List<ProductModel>>> _loadProducts() async {
    try {
      final produtos = await _productRepository.carregarProdutos();

      setProdutos(produtos);

      return Success(produtos);
    } catch (_) {
      rethrow;
    }
  }

  Future<Result<List<ProductModel>>> _loadMyProducts() async {
    try {
      final produtos = await _productRepository.carregarMeusProdutos();

      setMeusProdutos(produtos);

      return Success(produtos);
    } catch (_) {
      rethrow;
    }
  }

  Future<Result<List<ProductModel>>> _loadFavoritesProducts() async {
    try {
      final produtos = await _productRepository.carregarProdutosFavoritos();

      setProdutosFavoritos(produtos);

      return Success(produtos);
    } catch (_) {
      rethrow;
    }
  }

  List<ProductModel> searchByName(String query) {
    final q = query.toLowerCase();

    final lista = _produtos.where((p) {
      return p.name.toLowerCase().contains(q);
    }).toList();

    return lista.toList();
  }

  List<ProductModel> produtosPorCategoria(String categoryId) {
    final lista = _produtos.where((p) {
      return p.categories.contains(categoryId);
    }).toList();

    return lista.toList();
  }

  Future<void> salvarProduto(Map<String, Object> data) async {
    final hasId = data["id"] != null;

    final produto = ProductModel(
      id: hasId ? data["id"].toString() : null,
      name: data["name"] as String,
      description: data["description"] as String,
      price: data["price"] as double,
      quantity: data["quantity"] as int,
      imageUrls: data["imageUrls"] as List<ProductImageModel>,
      categories: List<String>.from(data["categories"] as List<String>),
      isPromotional: data["isPromotional"] as bool,
      discountPercentage: data["discountPercentage"] as int?,
      promotionEndDate: data["promotionEndDate"] != null
          ? DateTime.parse(data["promotionEndDate"] as String)
          : null,
    );

    if (hasId) {
      await atualizarProduto(produto);
    } else {
      await adicionarProduto(produto);
    }
  }

  Future<void> adicionarProduto(ProductModel produto) async {
    final id = await _productRepository.adicionarProduto(produto);

    final novoProduto = produto.copyWith(id: id);

    setMeusProdutos([..._meusProdutos, novoProduto]);
  }

  Future<void> atualizarProduto(ProductModel produto) async {
    final data = await _productRepository.atualizarProduto(
      produto,
    );

    final lista = _meusProdutos.map((e) => e.id == data.id ? data : e).toList();

    setMeusProdutos(lista);
  }

  Future<void> deletarProduto(ProductModel produto) async {
    try {
      await _productRepository.deletarProduto(produto.id!);
      final lista = _produtos.where((p) => p.id != produto.id).toList();
      setMeusProdutos(lista);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> adicionarOuRemoverFavorito(String productId) async {
    ProductModel? product;

    final indexProdutos = _produtos.indexWhere((p) => p.id == productId);

    if (indexProdutos != -1) {
      product = _produtos[indexProdutos];
    } else {
      final indexFavoritos =
          _produtosFavoritos.indexWhere((p) => p.id == productId);

      if (indexFavoritos != -1) {
        product = _meusProdutos[indexFavoritos];
      }
    }

    if (product == null) return;

    final oldValue = product.isFavorite;
    final isFavoritando = !oldValue;

    product.isFavorite = isFavoritando;
    notifyListeners();

    try {
      await _productRepository.adicionarOuRemoverFavorito(
        productId: productId,
        isFavorite: isFavoritando,
      );

      if (isFavoritando) {
        final exists = _produtosFavoritos.any((p) => p.id == productId);

        if (!exists) {
          _produtosFavoritos.add(product.copyWith(isFavorite: true));
        }
      } else {
        _produtosFavoritos.removeWhere((p) => p.id == productId);
      }

      notifyListeners();
    } catch (e) {
      product.isFavorite = oldValue;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> guardarProdutoPesquisado(String productId) async {
    await _productRepository.guardarProdutoPesquisado(
      productId: productId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<Result<List<ProductModel>>> _loadResearchedProducts() async {
    final result = await _productRepository.getProdutosPesquisados();

    if (result.isEmpty) {
      return Failure(throw Exception("Lista não encontrada"));
    }

    setProdutosVisualizados(result);

    return Success(result);
  }
}
