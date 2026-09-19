import 'dart:convert';

class PreferencesUserModel {
  final bool? exibirProdutosFavoritos;
  final bool? exibirProdutosVisualizados;
  final bool? receberNotificacoes;
  final bool? notificarPromocoes;
  final bool? notificarAtualizacaoPedido;
  final bool? salvarHistoricoVisualizacao;

  PreferencesUserModel({
    this.exibirProdutosFavoritos = true,
    this.exibirProdutosVisualizados = true,
    this.receberNotificacoes = true,
    this.notificarPromocoes = true,
    this.notificarAtualizacaoPedido = true,
    this.salvarHistoricoVisualizacao = true,
  });

  PreferencesUserModel copyWith({
    bool? exibirProdutosFavoritos,
    bool? exibirProdutosVisualizados,
    bool? receberNotificacoes,
    bool? notificarPromocoes,
    bool? notificarAtualizacaoPedido,
    bool? salvarHistoricoVisualizacao,
  }) {
    return PreferencesUserModel(
      exibirProdutosFavoritos:
          exibirProdutosFavoritos ?? this.exibirProdutosFavoritos,
      exibirProdutosVisualizados:
          exibirProdutosVisualizados ?? this.exibirProdutosVisualizados,
      receberNotificacoes: receberNotificacoes ?? this.receberNotificacoes,
      notificarPromocoes: notificarPromocoes ?? this.notificarPromocoes,
      notificarAtualizacaoPedido:
          notificarAtualizacaoPedido ?? this.notificarAtualizacaoPedido,
      salvarHistoricoVisualizacao:
          salvarHistoricoVisualizacao ?? this.salvarHistoricoVisualizacao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'exibirProdutosFavoritos': exibirProdutosFavoritos,
      'exibirProdutosVisualizados': exibirProdutosVisualizados,
      'receberNotificacoes': receberNotificacoes,
      'notificarPromocoes': notificarPromocoes,
      'notificarAtualizacaoPedido': notificarAtualizacaoPedido,
      'salvarHistoricoVisualizacao': salvarHistoricoVisualizacao,
    };
  }

  factory PreferencesUserModel.fromMap(Map<String, dynamic> map) {
    return PreferencesUserModel(
      exibirProdutosFavoritos: map['exibirProdutosFavoritos'] as bool,
      exibirProdutosVisualizados: map['exibirProdutosVisualizados'] as bool,
      receberNotificacoes: map['receberNotificacoes'] as bool,
      notificarPromocoes: map['notificarPromocoes'] as bool,
      notificarAtualizacaoPedido: map['notificarAtualizacaoPedido'] as bool,
      salvarHistoricoVisualizacao: map['salvarHistoricoVisualizacao'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreferencesUserModel.fromJson(String source) =>
      PreferencesUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
