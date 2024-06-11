import 'package:cloud_firestore/cloud_firestore.dart';

class Sku {
  int productId;
  int productDetailId;
  double buyingPrice;
  double sellingPrice;
  String status;
  String sellDate;
  String color;
  String size;

  Sku({
    required this.productId,
    required this.productDetailId,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.status,
    required this.sellDate,
    required this.color,
    required this.size,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_detail_id': productDetailId,
      'buy_price': buyingPrice,
      'sell_price': sellingPrice,
      'status': status,
      'sell_date': sellDate,
      'color': color,
      'size': size,
    };
  }

  // Extract a User object from a DocumentSnapshot
  factory Sku.fromDocument(DocumentSnapshot doc) {
    return Sku(
      color: doc['color'],
      size: doc['size'],
      buyingPrice: doc['email'],
      sellingPrice: doc['first_name'],
      status: doc['last_name'],
      sellDate: doc['user_id'],
      productId: doc['product_id'],
      productDetailId: doc['product_detail_id'],
    );
  }
}
