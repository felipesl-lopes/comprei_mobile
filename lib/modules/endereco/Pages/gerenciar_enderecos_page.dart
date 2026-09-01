import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/core/widgets/feedback_message.dart';
import 'package:appshop/modules/endereco/providers/endereco_provider.dart';
import 'package:appshop/modules/endereco/widgets/endereco_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GerenciarEnderecosPage extends StatefulWidget {
  const GerenciarEnderecosPage({super.key});

  @override
  State<GerenciarEnderecosPage> createState() => _GerenciarEnderecosPageState();
}

class _GerenciarEnderecosPageState extends State<GerenciarEnderecosPage> {
  String? _selectedEnderecoId;

  @override
  Widget build(BuildContext context) {
    final enderecoProvider = context.watch<EnderecoProvider>();
    final enderecos = enderecoProvider.enderecos;

    return Scaffold(
      appBar: BackAppBar(title: 'Gerenciar endereço'),
      body: ListenableBuilder(
        listenable: enderecoProvider.loadAddressCommand,
        builder: (context, _) {
          final enderecoValue = enderecoProvider.loadAddressCommand.value;

          if (enderecoValue.isRunning) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (enderecoValue.isFailure) {
            return Center(
              child: FeedbackMessage(
                  message: "Não foi possível carregar os endereços.",
                  icon: Icons.error_outline),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Adicione, edite ou remova seus endereços.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              EnderecoListWidget(
                  enderecos: enderecos,
                  selectedEnderecoId: _selectedEnderecoId,
                  onSelected: (enderecoId) {
                    setState(() {
                      _selectedEnderecoId = enderecoId;
                    });
                  }),
              if (enderecos.length < 3) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    onPressed: () async => await Navigator.of(context)
                        .pushNamed(AppRoutes.NOVO_ENDERECO),
                    child: Text('Novo endereço',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}
