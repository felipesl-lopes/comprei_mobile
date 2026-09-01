import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/core/widgets/feedback_message.dart';
import 'package:appshop/core/widgets/send_button.dart';
import 'package:appshop/modules/endereco/providers/endereco_provider.dart';
import 'package:appshop/modules/endereco/widgets/endereco_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelecionarEnderecoPage extends StatefulWidget {
  const SelecionarEnderecoPage({super.key});

  @override
  State<SelecionarEnderecoPage> createState() => _SelecionarEnderecoPageState();
}

class _SelecionarEnderecoPageState extends State<SelecionarEnderecoPage> {
  String? _selectedEnderecoId;

  @override
  Widget build(BuildContext context) {
    final enderecoProvider = context.watch<EnderecoProvider>();
    final enderecos = enderecoProvider.enderecos;

    return Scaffold(
      appBar: BackAppBar(title: 'Selecionar endereço'),
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
                  'Selecione o endereço da entrega.',
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
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: SendButton(
                  'Voltar',
                  () => Navigator.of(context).pop(),
                  secondaryButton: true,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: SendButton(
                  'Continuar',
                  _selectedEnderecoId == null
                      ? null
                      : () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.FINALIZE_PURCHASE,
                            arguments: _selectedEnderecoId,
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
