import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final int productId;
  final String title;
  final String type;
  final List<ProductDetail> productDetails;

  Product({
    required this.productId,
    required this.title,
    required this.type,
    required this.productDetails,
  });

  factory Product.fromFirestore(Map<String, dynamic> json) {
    List<ProductDetail> productDetails = [];
    if (json['productDetails'] != null) {
      productDetails = List<ProductDetail>.from(
        json['productDetails'].map(
          (detail) => ProductDetail.fromFirestore(detail),
        ),
      );
    }

    return Product(
      productId: json['productId'],
      title: json['title'],
      type: json['type'],
      productDetails: productDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'type': type,
      /* 'productDetails': productDetails.map((detail) => detail.toMap()).toList(),*/
    };
  }
}

class ProductDetail {
  final String sku;
  final String title;
  final String type;
  final String size;
  final String color;
  final String description;
  final List<String> photos;
  final List<ProductBatch> batches;
  final int inStock;

  ProductDetail({
    required this.sku,
    required this.size,
    required this.title,
    required this.type,
    required this.color,
    required this.description,
    required this.photos,
    required this.batches,
    required this.inStock,
  });

  factory ProductDetail.fromFirestore(Map<String, dynamic> json) {
    List<ProductBatch> batches = [];
    if (json['batches'] != null) {
      batches = List<ProductBatch>.from(
        json['batches'].map(
          (batch) => ProductBatch.fromFirestore(batch),
        ),
      );
    }

    return ProductDetail(
      type: json['type'],
      title: json['title'],
      sku: json['sku'],
      size: json['size'],
      color: json['color'],
      inStock: json['in_stock'],
      description: json['description'],
      photos: List<String>.from(json['photos']),
      batches: batches,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'sku': sku,
      'size': size,
      'color': color,
      'in_stock': inStock,
      'description': description, // Include description field in map
      'photos': photos,
      /*'batches': batches.map((batch) => batch.toMap()).toList(),*/
    };
  }

  Map<String, dynamic> toMap2() {
    return {
      'title': title,
      'type': type,
      'sku': sku,
      'size': size,
      'color': color,
      'in_stock': inStock,
      'description': description, // Include description field in map
      'photos': photos,
      'batches': batches.map((batch) => batch.toMap()).toList(),
    };
  }
}

class ProductBatch {
  final int batchId;
  final int quantity;
  final int available;
  final double buyPrice;
  final double sellPrice;
  final String supplierName;
  final DateTime date;

  ProductBatch({
    required this.date,
    required this.supplierName,
    required this.batchId,
    required this.quantity,
    required this.available,
    required this.buyPrice,
    required this.sellPrice,
  });

  factory ProductBatch.fromFirestore(Map<String, dynamic> json) {
    return ProductBatch(
      supplierName: json['supplier_name'],
      batchId: json['batchId'],
      quantity: json['quantity'],
      available: json['available'],
      buyPrice: json['buy_price'].toDouble(),
      sellPrice: json['sell_price'].toDouble(),
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supplier_name': supplierName,
      'batchId': batchId,
      'quantity': quantity,
      'available': available,
      'buy_price': buyPrice,
      'sell_price': sellPrice,
      'date': Timestamp.fromDate(date),
    };
  }
}
