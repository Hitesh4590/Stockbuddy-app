import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final int orderId;
  final String retailerName;
  final String customerName;
  final String customerPhone;
  final List<OrderedProduct> orderedProducts;
  final DateTime date;
  final double totalAmount;
  final int totalItems;
  final String channel;
  final String paymentMode;

  Order({
    required this.paymentMode,
    required this.channel,
    required this.orderId,
    required this.retailerName,
    required this.customerName,
    required this.customerPhone,
    required this.orderedProducts,
    required this.date,
    required this.totalAmount,
  }) : totalItems = orderedProducts.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromFirestore(Map<String, dynamic> json) {
    List<OrderedProduct> orderedProducts = [];
    if (json['orderedProducts'] != null) {
      orderedProducts = List<OrderedProduct>.from(
        json['orderedProducts'].map(
          (product) => OrderedProduct.fromFirestore(product),
        ),
      );
    }

    return Order(
      paymentMode: json['payment_mode'],
      channel: json['channel'],
      orderId: json['orderId'],
      retailerName: json['retailerName'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      orderedProducts: orderedProducts,
      date: (json['date'] as Timestamp).toDate(),
      totalAmount: json['totalAmount'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payment_mode': paymentMode,
      'channel': channel,
      'orderId': orderId,
      'retailerName': retailerName,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'orderedProducts':
          orderedProducts.map((product) => product.toMap()).toList(),
      'date': Timestamp.fromDate(date),
      'totalAmount': totalAmount,
      'totalItems': totalItems,
    };
  }
}

class OrderedProduct {
  final String? photos;
  final String sku;
  final String title;
  final int quantity;
  final List<ProductBatchOrder> batchOrders;

  OrderedProduct({
    this.photos,
    required this.sku,
    required this.title,
    required this.quantity,
    required this.batchOrders,
  });

  factory OrderedProduct.fromFirestore(Map<String, dynamic> json) {
    List<ProductBatchOrder> batchOrders = [];
    if (json['batchOrders'] != null) {
      batchOrders = List<ProductBatchOrder>.from(
        json['batchOrders'].map(
          (batchOrder) => ProductBatchOrder.fromFirestore(batchOrder),
        ),
      );
    }

    return OrderedProduct(
      photos: json['photos'],
      sku: json['sku'],
      title: json['title'],
      quantity: json['quantity'],
      batchOrders: batchOrders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'photos': photos,
      'sku': sku,
      'title': title,
      'quantity': quantity,
      'batchOrders':
          batchOrders.map((batchOrder) => batchOrder.toMap()).toList(),
    };
  }
}

class ProductBatchOrder {
  final int batchId;
  final int quantity;
  final double price;
  final String supplierName;

  ProductBatchOrder({
    required this.batchId,
    required this.quantity,
    required this.price,
    required this.supplierName,
  });

  factory ProductBatchOrder.fromFirestore(Map<String, dynamic> json) {
    return ProductBatchOrder(
      supplierName: json['supplier_name'],
      batchId: json['batchId'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supplier_name': supplierName,
      'batchId': batchId,
      'quantity': quantity,
      'price': price,
    };
  }
}
