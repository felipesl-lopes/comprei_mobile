import 'package:appshop/core/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDataSource {
  Future<List<Map<String, dynamic>>> carregarProdutosPesquisados() async {
    final db = await AppDatabase.database;

    final result = await db.query('produtos_recentes_visualizados');

    return result;
  }

  Future<void> inserirProdutoPesquisado(String id, int timestamp) async {
    final db = await AppDatabase.database;

    await db.transaction(
      (txn) async {
        await txn.insert(
          'produtos_recentes_visualizados',
          {
            'id': id,
            'timestamp': timestamp,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await txn.rawDelete('''
          DELETE FROM produtos_recentes_visualizados 
          WHERE id NOT in (
            SELECT id 
            FROM produtos_recentes_visualizados 
            ORDER BY timestamp DESC 
            LIMIT 5
          )
        ''');
      },
    );
  }
}
