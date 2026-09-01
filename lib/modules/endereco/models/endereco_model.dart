import 'dart:convert';

class EnderecoModel {
  final String? id;
  final String cep;
  final String rua;
  final String numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String uf;

  EnderecoModel({
    required this.id,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.uf,
  });

  EnderecoModel copyWith({
    String? id,
    String? cep,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? uf,
  }) {
    return EnderecoModel(
      id: id ?? this.id,
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
    };
  }

  // Para toMap no SQLite
  Map<String, dynamic> toDatabaseMap() {
    return <String, dynamic>{
      'id': id,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
    };
  }

  factory EnderecoModel.fromMap(Map<String, dynamic> map) {
    return EnderecoModel(
      id: map['id'] as String?,
      cep: map['cep'],
      rua: map['rua'],
      numero: map['numero'],
      complemento: map['complemento'] ?? '',
      bairro: map['bairro'],
      cidade: map['cidade'],
      uf: map['uf'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EnderecoModel.fromJson(String id, String source) =>
      EnderecoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EnderecoModel(id: $id, cep: $cep, rua: $rua, numero: $numero, complemento: $complemento, bairro: $bairro, cidade: $cidade, uf: $uf)';
  }

  @override
  bool operator ==(covariant EnderecoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.cep == cep &&
        other.rua == rua &&
        other.numero == numero &&
        other.complemento == complemento &&
        other.bairro == bairro &&
        other.cidade == cidade &&
        other.uf == uf;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cep.hashCode ^
        rua.hashCode ^
        numero.hashCode ^
        complemento.hashCode ^
        bairro.hashCode ^
        cidade.hashCode ^
        uf.hashCode;
  }
}
