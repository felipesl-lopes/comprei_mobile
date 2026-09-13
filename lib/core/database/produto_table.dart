class ProdutoTable {
  static const String tableName = 'produtos_recentes_visualizados';

  static const String createTable = '''
    CREATE TABLE $tableName (
      id TEXT PRIMARY KEY,
      timestamp INTEGER NOT NULL
    )
  ''';
}
