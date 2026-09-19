import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/profile/models/preferences_user_model.dart';
import 'package:flutter/widgets.dart';

class PreferencesRepository {
  final IHttpClient _client;

  PreferencesRepository(this._client);

  Future<PreferencesUserModel> carregarPreferencias() async {
    debugPrint('[PreferencesRepository]: carregarPreferencias');

    try {
      final response = await _client.get('user/preferences');

      if (!response.isSuccess) {
        throw Exception('Não foi possivel carregar preferencias');
      }

      return PreferencesUserModel.fromMap(
          response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Não foi possível carregar as preferências.');
    }
  }

  Future<void> alterarPreferencia({
    required String campo,
    required bool valor,
  }) async {
    debugPrint('[PreferencesRepository]: alterarPreferencia');

    try {
      final response = await _client.patch(
        'user/preferences',
        body: {
          campo: valor,
        },
      );

      if (!response.isSuccess) {
        throw Exception('Não foi possivel alterar preferencia');
      }
    } catch (e) {
      throw Exception('Não foi possível alterar preferência');
    }
  }
}
