import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String customerName;
  String customerPhone;
  String orderId;
  double price;
  int quantity;
  String skuNo;
  String date;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.orderId,
    required this.price,
    required this.quantity,
    required this.skuNo,
    required this.date,
  });

  // Convert an Order object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'order_id': orderId,
      'price': price,
      'quantity': quantity,
      'sku_no': skuNo,
      'date': date,
    };
  }

  // Extract an Order object from a DocumentSnapshot
  factory Order.fromDocument(DocumentSnapshot doc) {
    return Order(
      id: doc.id,
      customerName: doc['customer_name'],
      customerPhone: doc['customer_phone'],
      orderId: doc['order_id'],
      price: doc['price'],
      quantity: doc['quantity'],
      skuNo: doc['sku_no'],
      date: doc['date'],
    );
  }
}
