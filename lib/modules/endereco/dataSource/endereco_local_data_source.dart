import 'package:appshop/core/database/app_database.dart';
import 'package:appshop/modules/endereco/models/endereco_model.dart';
import 'package:sqflite/sqflite.dart';

class EnderecoLocalDataSource {
  Future<void> inserirEndereco(EnderecoModel endereco) async {
    final db = await AppDatabase.database;

    await db.insert(
      'enderecos',
      endereco.toDatabaseMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> limparEnderecos() async {
    final db = await AppDatabase.database;

    await db.delete('enderecos');
  }
}
