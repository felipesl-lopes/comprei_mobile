import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/enums/endereco_result_action.dart';
import 'package:appshop/core/utils/flushbar_helper.dart';
import 'package:appshop/modules/endereco/models/endereco_model.dart';
import 'package:flutter/material.dart';

class EnderecoListWidget extends StatelessWidget {
  final List enderecos;
  final String? selectedEnderecoId;
  final ValueChanged<String> onSelected;

  const EnderecoListWidget({
    super.key,
    required this.enderecos,
    required this.selectedEnderecoId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: enderecos.length,
      itemBuilder: (context, index) {
        final EnderecoModel end = enderecos[index];
        final isSelected = selectedEnderecoId == end.id;

        return GestureDetector(
          onTap: () => onSelected(end.id!),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2,
              ),
              color: isSelected ? Colors.blue.withOpacity(0.12) : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${end.rua}, ${end.numero}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (end.complemento.isNotEmpty) Text(end.complemento),
                Text(
                  "${end.bairro} - ${end.cidade}/${end.uf}",
                ),
                Text(
                  "CEP: ${end.cep}",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).pushNamed(
                        AppRoutes.NOVO_ENDERECO,
                        arguments: end,
                      );

                      if (!context.mounted) return;

                      if (result == EnderecoResultAction.updated) {
                        showAppFlushbar(
                          context,
                          message: 'Endereço atualizado',
                          type: FlushType.success,
                          position: FlushPosition.top,
                        );
                      }

                      if (result == EnderecoResultAction.created) {
                        showAppFlushbar(
                          context,
                          message: 'Endereço adicionado',
                          type: FlushType.success,
                          position: FlushPosition.top,
                        );
                      }

                      if (result == EnderecoResultAction.deleted) {
                        showAppFlushbar(
                          context,
                          message: 'Endereço removido',
                          type: FlushType.success,
                          position: FlushPosition.top,
                        );
                      }
                    },
                    child: const Text(
                      'Editar endereço',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
