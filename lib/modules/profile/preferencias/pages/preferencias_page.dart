import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/modules/profile/preferencias/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferenciasPage extends StatefulWidget {
  const PreferenciasPage({super.key});

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PreferencesProvider>();
    final preferences = provider.preferences;

    return Scaffold(
      appBar: BackAppBar(
        title: "Preferências",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Home"),
            _switch(
              text: "Exibir produtos recentes",
              campo: 'exibirProdutosVisualizados',
              valor: preferences?.exibirProdutosVisualizados,
            ),
            _switch(
              text: "Exibir produtos favoritos",
              campo: 'exibirProdutosFavoritos',
              valor: preferences?.exibirProdutosFavoritos,
            ),
            Divider(height: 32),
            _sectionTitle("Notificações"),
            _switch(
              text: 'Receber notificações',
              campo: 'receberNotificacoes',
              valor: preferences?.receberNotificacoes,
            ),
            _switch(
              text: 'Atualizações de pedidos',
              campo: 'notificarAtualizacaoPedido',
              valor: preferences?.notificarAtualizacaoPedido,
            ),
            _switch(
              text: 'Promoções',
              campo: 'notificarPromocoes',
              valor: preferences?.notificarPromocoes,
            ),
            Divider(height: 32),
            _sectionTitle("Histórico"),
            _switch(
              text: 'Salvar histórico de visualizações',
              campo: 'salvarHistoricoVisualizacao',
              valor: preferences?.salvarHistoricoVisualizacao,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        bottom: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _switch({
    required String text,
    required String campo,
    required bool? valor,
  }) {
    return SwitchListTile(
      title: Text(text),
      value: valor ?? true,
      onChanged: (value) {
        context.read<PreferencesProvider>().alterarPreferencia(
              campo,
              value,
            );
      },
    );
  }
}
