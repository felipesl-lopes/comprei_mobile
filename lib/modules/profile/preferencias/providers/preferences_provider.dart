import 'package:appshop/modules/profile/models/preferences_user_model.dart';
import 'package:appshop/modules/profile/preferencias/repositories/preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class PreferencesProvider with ChangeNotifier {
  final PreferencesRepository _preferencesRepository;

  late final Command0<PreferencesUserModel> loadPreferencesCommand;

  PreferencesProvider(
    this._preferencesRepository,
  ) {
    loadPreferencesCommand = Command0(_loadPreferences);
  }

  PreferencesUserModel? _preferences;

  PreferencesUserModel? get preferences => _preferences;

  Future<Result<PreferencesUserModel>> _loadPreferences() async {
    final data = await _preferencesRepository.carregarPreferencias();

    _preferences = data;

    notifyListeners();

    return Success(data);
  }

  Future<void> alterarPreferencia(String campo, bool valor) async {
    if (_preferences == null) return;

    final anterior = _preferences;

    final map = _preferences!.toMap();
    map[campo] = valor;

    _preferences = PreferencesUserModel.fromMap(map);
    notifyListeners();

    try {
      await _preferencesRepository.alterarPreferencia(
        campo: campo,
        valor: valor,
      );
    } catch (e) {
      _preferences = anterior;
      notifyListeners();
      rethrow;
    }
  }
}
