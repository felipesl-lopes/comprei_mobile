import 'dart:io';

import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/endereco/models/endereco_model.dart';
import 'package:flutter/material.dart';

class EnderecoRepository {
  final IHttpClient _client;

  EnderecoRepository(this._client);

  Future<List<EnderecoModel>> carregarEnderecos() async {
    debugPrint('[CartRepository]: carregarEnderecos');

    try {
      final response = await _client.get('address');

      final data = response.data;

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao buscar endereços');
      }

      if (data == null) return [];

      final enderecos = (data as List)
          .map((e) => EnderecoModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return enderecos;
    } catch (e) {
      debugPrint('Erro ao carregar endereços.' + e.toString());
      throw Exception('Erro ao carregar endereços.');
    }
  }

  Future<EnderecoModel> buscarEndereco({
    required String enderecoId,
  }) async {
    debugPrint('[CartRepository]: buscarEndereco');

    try {
      final response = await _client.get('address/$enderecoId');

      final Map<String, dynamic> data = response.data;

      return EnderecoModel.fromMap(data);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao buscar endereço');
    }
  }

  Future<EnderecoModel> adicionarEndereco({
    required EnderecoModel endereco,
  }) async {
    debugPrint('[CartRepository]: adicionarEndereco');

    try {
      final response = await _client.post(
        'address',
        body: endereco.toMap(),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao adicionar endereço');
      }

      final data = EnderecoModel.fromMap(response.data);

      return data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao adicionar endereço.');
    }
  }

  Future<void> editarEndereco({
    required EnderecoModel endereco,
  }) async {
    debugPrint('[CartRepository]: editarEndereco');

    try {
      final response = await _client.put(
        'address/${endereco.id}',
        body: endereco.toMap(),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao editar endereço');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao editar endereço.');
    }
  }

  Future<void> removerEndereco({
    required String addressId,
  }) async {
    debugPrint('[CartRepository]: removerEndereco');

    try {
      await _client.delete('address/$addressId');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao remover endereço.');
    }
  }
}
