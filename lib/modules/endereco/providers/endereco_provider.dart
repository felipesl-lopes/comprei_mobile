import 'dart:async';

import 'package:appshop/modules/endereco/models/endereco_model.dart';
import 'package:appshop/modules/endereco/repositories/endereco_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class EnderecoProvider with ChangeNotifier {
  final EnderecoRepository _enderecoRepository;

  late final Command0<List<EnderecoModel>> loadAddressCommand;

  EnderecoProvider(
    this._enderecoRepository,
  ) {
    loadAddressCommand = Command0(_loadAddress);
  }

  List<EnderecoModel> _enderecos = [];
  List<EnderecoModel> get enderecos => [..._enderecos];

  void setEnderecos(List<EnderecoModel> value) {
    _enderecos = value;
    notifyListeners();
  }

  void clear() {
    _enderecos.clear();
    notifyListeners();
  }

  Future<Result<List<EnderecoModel>>> _loadAddress() async {
    try {
      final enderecosAtualizados =
          await _enderecoRepository.carregarEnderecos();

      setEnderecos(enderecosAtualizados);

      return Success(enderecosAtualizados);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> adicionarEndereco(
    EnderecoModel endereco,
  ) async {
    try {
      final response = await _enderecoRepository.adicionarEndereco(
        endereco: endereco,
      );

      _enderecos.add(response);

      setEnderecos(_enderecos);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editarEndereco(EnderecoModel endereco) async {
    try {
      await _enderecoRepository.editarEndereco(endereco: endereco);

      final listaAtualizada = _enderecos.map((e) {
        return e.id == endereco.id ? endereco : e;
      }).toList();

      setEnderecos(listaAtualizada);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removerEndereco(String enderecoId) async {
    try {
      await _enderecoRepository.removerEndereco(
        addressId: enderecoId,
      );

      final listaAtualizada = List<EnderecoModel>.from(_enderecos)
        ..removeWhere((e) => e.id == enderecoId);

      setEnderecos(listaAtualizada);
    } catch (e) {}
  }
}
