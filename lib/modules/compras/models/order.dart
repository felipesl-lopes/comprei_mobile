// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appshop/modules/compras/models/orderStatus.dart';
import 'package:flutter/foundation.dart';

import 'package:appshop/modules/compras/models/compras_model.dart';
import 'package:appshop/modules/endereco/models/endereco_model.dart';

class Order {
  final String id;
  final double total;
  final List<ComprasModel> products;
  final DateTime date;
  final EnderecoModel? endereco;
  final OrderStatus? orderStatus;
  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
    this.orderStatus,
    this.endereco,
  });

  Order copyWith({
    String? id,
    double? total,
    List<ComprasModel>? products,
    DateTime? date,
    EnderecoModel? endereco,
  }) {
    return Order(
      id: id ?? this.id,
      total: total ?? this.total,
      products: products ?? this.products,
      date: date ?? this.date,
      endereco: endereco ?? this.endereco,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'total': total,
      'products': products.map((x) => x.toMap()).toList(),
      'date': date.millisecondsSinceEpoch,
      'address': endereco?.toMap(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
        id: map['id'] as String,
        total: (map["total"] as num).toDouble(),
        products: (map["products"] as List)
            .map((item) => ComprasModel.fromMap(
                  Map<String, dynamic>.from(item),
                ))
            .toList(),
        date: DateTime.parse(map["date"]),
        endereco: map['address'] != null
            ? EnderecoModel.fromMap(map['address'])
            : null,
        orderStatus: OrderStatus.values.byName(map['status'] ?? 'pending'));
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, total: $total, products: $products, date: $date, endereco: $endereco)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.total == total &&
        listEquals(other.products, products) &&
        other.date == date &&
        other.endereco == endereco;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        total.hashCode ^
        products.hashCode ^
        date.hashCode ^
        endereco.hashCode;
  }
}
