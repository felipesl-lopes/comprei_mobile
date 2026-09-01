class AddressTable {
  static const String tableName = 'enderecos';

  static const String createTable = '''
    CREATE TABLE $tableName (
      id TEXT PRIMARY KEY,
      cep TEXT NOT NULL,
      rua TEXT NOT NULL,
      numero TEXT NOT NULL,
      complemento TEXT NOT NULL,
      bairro TEXT NOT NULL,
      cidade TEXT NOT NULL,
      uf TEXT NOT NULL
    )
  ''';
}
