import 'dart:async';

import 'package:appshop/modules/cart/models/cart_product_model.dart';
import 'package:appshop/modules/cart/repositories/cart_repository.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _cartRepository;
  final ProductProvider _productProvider;

  late final Command0<List<CartProductModel>> loadCartCommand;

  CartProvider(
    this._cartRepository,
    this._productProvider,
  ) {
    loadCartCommand = Command0(_loadCart);
  }

  /// Timers de debounce por produto
  final Map<String, Timer> _debounces = {};

  /// Armazena o estado do item antes do início das alterações otimistas
  final Map<String, CartProductModel?> _originalItems = {};

  List<CartProductModel> _carrinhoDeProdutos = [];
  List<CartProductModel> get carrinhoDeProdutos => [..._carrinhoDeProdutos];

  void setCarrinhoDeProdutos(List<CartProductModel> value) {
    _carrinhoDeProdutos = value;
    notifyListeners();
  }

  void clear() {
    for (var timer in _debounces.values) {
      timer.cancel();
    }
    _debounces.clear();
    _originalItems.clear();
    _carrinhoDeProdutos.clear();
    notifyListeners();
  }

  int get totalDeItens {
    return _carrinhoDeProdutos.length;
  }

  double get valorTotal {
    return _carrinhoDeProdutos.fold(
      0.0,
      (total, item) {
        final preco = item.product.valorFinalDoProduto();
        return total + (preco * item.quantity);
      },
    );
  }

  Future<Result<List<CartProductModel>>> _loadCart() async {
    try {
      final productsMap = {for (var p in _productProvider.produtos) p.id!: p};

      final data = await _cartRepository.carregarCarrinho(
        productsMap: productsMap,
      );

      setCarrinhoDeProdutos(data);

      return Success(data);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> adcItemAoCarrinho(
    ProductModel product, {
    void Function(Object error)? onError,
  }) async {
    final productId = product.id;
    if (productId == null) return;

    final index =
        _carrinhoDeProdutos.indexWhere((e) => e.product.id == productId);

    if (index >= 0) {
      final existing = _carrinhoDeProdutos[index];
      if (existing.quantity >= product.quantity) {
        throw Exception("Quantidade máxima atingida.");
      }
    }

    // Salva o estado original antes do primeiro clique da sequência
    if (!_originalItems.containsKey(productId)) {
      _originalItems[productId] =
          index >= 0 ? _carrinhoDeProdutos[index] : null;
    }

    if (index >= 0) {
      final existing = _carrinhoDeProdutos[index];
      _carrinhoDeProdutos[index] = CartProductModel(
        product: existing.product,
        quantity: existing.quantity + 1,
      );
    } else {
      _carrinhoDeProdutos.add(
        CartProductModel(
          product: product,
          quantity: 1,
        ),
      );
    }

    notifyListeners();

    _debounces[productId]?.cancel();
    _debounces[productId] = Timer(const Duration(milliseconds: 400), () async {
      final itemIndex =
          _carrinhoDeProdutos.indexWhere((e) => e.product.id == productId);
      final currentQuantity =
          itemIndex >= 0 ? _carrinhoDeProdutos[itemIndex].quantity : 0;

      try {
        await _cartRepository.atualizarQuantidadeDeItens(
          productId: productId,
          quantity: currentQuantity,
        );
        _originalItems.remove(productId);
      } catch (e) {
        _rollback(productId);
        // Notifica a UI via callback se fornecido
        onError?.call(e);
      } finally {
        _debounces.remove(productId);
      }
    });
  }

  Future<void> removeSingleItem(
    String productId, {
    void Function(Object error)? onError,
  }) async {
    final index =
        _carrinhoDeProdutos.indexWhere((e) => e.product.id == productId);

    if (index < 0) return;

    // Salva o estado original antes do primeiro clique da sequência
    if (!_originalItems.containsKey(productId)) {
      _originalItems[productId] = _carrinhoDeProdutos[index];
    }

    final existing = _carrinhoDeProdutos[index];

    if (existing.quantity == 1) {
      _carrinhoDeProdutos.removeAt(index);
    } else {
      _carrinhoDeProdutos[index] = CartProductModel(
        product: existing.product,
        quantity: existing.quantity - 1,
      );
    }

    notifyListeners();

    _debounces[productId]?.cancel();
    _debounces[productId] = Timer(const Duration(milliseconds: 400), () async {
      final itemIndex =
          _carrinhoDeProdutos.indexWhere((e) => e.product.id == productId);
      final currentQuantity =
          itemIndex >= 0 ? _carrinhoDeProdutos[itemIndex].quantity : 0;

      try {
        await _cartRepository.atualizarQuantidadeDeItens(
          productId: productId,
          quantity: currentQuantity,
        );
        _originalItems.remove(productId);
      } catch (e) {
        _rollback(productId);
        // Notifica a UI via callback se fornecido
        onError?.call(e);
      } finally {
        _debounces.remove(productId);
      }
    });
  }

  /// Restaura o item para o estado em que estava antes do início da operação
  void _rollback(String productId) {
    if (!_originalItems.containsKey(productId)) return;

    final originalItem = _originalItems.remove(productId);
    final index =
        _carrinhoDeProdutos.indexWhere((e) => e.product.id == productId);

    if (originalItem == null) {
      if (index >= 0) {
        _carrinhoDeProdutos.removeAt(index);
      }
    } else {
      if (index >= 0) {
        _carrinhoDeProdutos[index] = originalItem;
      } else {
        _carrinhoDeProdutos.add(originalItem);
      }
    }

    notifyListeners();
  }

  void limparCarrinho() {
    clear();
  }

  @override
  void dispose() {
    for (var timer in _debounces.values) {
      timer.cancel();
    }
    super.dispose();
  }
}
