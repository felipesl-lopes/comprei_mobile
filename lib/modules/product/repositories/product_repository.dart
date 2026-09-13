import 'package:appshop/core/database/dataSource/product_local_data_source.dart';
import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductRepository {
  final IHttpClient _client;
  final ProductLocalDataSource _localDataSource;

  ProductRepository(this._client, this._localDataSource);

  Future<List<ProductModel>> carregarProdutos() async {
    debugPrint('[ProductRepository]: carregarProdutos');

    try {
      final response = await _client.get('products');

      if (!response.isSuccess) {
        throw Exception('Não foi possível carregar os produtos.');
      }

      final produtos = (response.data as List)
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return produtos;
    } catch (e) {
      debugPrint('[ProductRepository - carregarProdutos]: ' + e.toString());
      throw Exception('Não foi possível carregar os produtos.');
    }
  }

  Future<List<ProductModel>> carregarMeusProdutos() async {
    debugPrint('[ProductRepository]: carregarMeusProdutos');

    try {
      final response = await _client.get('products/my');

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final produtos = (response.data as List)
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return produtos;
    } catch (e) {
      debugPrint('[ProductRepository - carregarMeusProdutos]: ' + e.toString());
      throw Exception("Não foi possível carregar seus produtos.");
    }
  }

  Future<List<ProductModel>> carregarProdutosFavoritos() async {
    debugPrint('[ProductRepository]: carregarProdutosFavoritos');

    try {
      final response = await _client.get('products/favorites');

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final produtos = (response.data as List)
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return produtos;
    } catch (e) {
      debugPrint(
          '[ProductRepository - carregarProdutosFavoritos]: ' + e.toString());
      throw Exception("Não foi possível carregar produtos favoritos.");
    }
  }

  Future<ProductModel?> buscarProdutoPorId(String productId) async {
    debugPrint('[ProductRepository]: buscarProdutoPorId:');

    try {
      final response = await _client.get('products/$productId');

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final data = response.data;

      return ProductModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String> adicionarProduto(ProductModel product) async {
    debugPrint('[ProductRepository]: adicionarProduto:');

    try {
      final response = await _client.post(
        'products',
        body: product.toMap(),
      );

      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao adicionar produto.');
    }
  }

  Future<ProductModel> atualizarProduto(ProductModel product) async {
    debugPrint('[ProductRepository]: atualizarProduto:');

    try {
      final response = await _client.patch(
        'products/${product.id}',
        body: product.toUpdateMap(),
      );

      if (response.statusCode > 400) {
        return throw Exception('Erro ao atualizar produto.');
      }

      final produto = ProductModel.fromMap(response.data);

      return produto;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao atualizar produto.');
    }
  }

  Future<void> deletarProduto(String idProduto) async {
    debugPrint('[ProductRepository]: deletarProduto:');

    try {
      final response = await _client.delete('products/$idProduto');

      if (response.statusCode >= 400) {
        throw GenericExeption.ExceptionMsg(
          msg: "Não foi possivel excluir o produto.",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao deletar produto.');
    }
  }

  Future<void> adicionarOuRemoverFavorito({
    required String productId,
    required bool isFavorite,
  }) async {
    debugPrint('[ProductRepository]: adicionarOuRemoverFavorito');

    try {
      if (isFavorite) {
        await _client.put(
          'userFavorites/$productId',
          body: {},
        );
      } else {
        await _client.delete('userFavorites/$productId');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao adicionar/remover favorito');
    }
  }

  Future<void> guardarProdutoPesquisado({
    required String productId,
    required int timestamp,
  }) async {
    debugPrint('[ProductRepository]: guardarProdutoPesquisado');

    try {
      await _localDataSource.inserirProdutoPesquisado(productId, timestamp);
    } catch (e) {
      debugPrint('Erro ao salvar produto pesquisado: $e');
    }
  }

  Future<List<ProductModel>> getProdutosPesquisados() async {
    debugPrint('[ProductRepository]: setProdutoPesquisado');

    try {
      final produtos = await _localDataSource.carregarProdutosPesquisados();

      final ids = produtos.map((produto) => produto['id'] as String).join(',');

      if (produtos.isEmpty) {
        return [];
      }

      final result = await _client.get(
        'products/researched',
        queryParameters: {'ids': ids},
      );

      if (result.statusCode >= 400) {
        return [];
      }

      final productList =
          (result.data as List).map((e) => ProductModel.fromMap(e)).toList();

      return productList;
    } catch (e) {
      rethrow;
    }
  }
}
