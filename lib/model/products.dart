import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  int? id;
  String? title;
  String? date;

  String? type;
  int? inStock;
  List<ProductDetails>? productDetails; // Change to List<ProductDetails>?

  Product({
    this.id,
    this.title,
    this.date,
    this.type,
    this.inStock,
    this.productDetails,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      id: doc['id'],
      title: doc['title'],
      date: doc['date'],
      type: doc['type'],
      inStock: doc['inStock'],
      productDetails: (doc['ProductDetails'] as List<dynamic>?)
          ?.map((e) => ProductDetails.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'type': type,
      'inStock': inStock,
      'ProductDetails': productDetails?.map((e) => e.toMap()).toList(),
    };
  }
}

class ProductDetails {
  int? id;
  int? productId;
  double? buyPrice;
  double? sellPrice;
  String? description;
  String? color;
  int? quantity;
  int? available;
  int? sold;
  String? size;
  String? supplierName;
  List<String>? photos;

  ProductDetails({
    this.id,
    this.productId,
    this.buyPrice,
    this.sellPrice,
    this.color,
    this.quantity,
    this.description,
    this.available,
    this.sold,
    this.size,
    this.supplierName,
    this.photos,
  });

  factory ProductDetails.fromMap(Map<String, dynamic> map) {
    return ProductDetails(
      id: map['id'],
      productId: map['ProductId'],
      buyPrice: map['buyPrice'],
      description: map['description'],
      sellPrice: map['sellPrice'],
      color: map['color'],
      quantity: map['quantity'],
      available: map['available'],
      sold: map['sold'],
      size: map['size'],
      supplierName: map['supplierName'],
      photos: List<String>.from(map['photos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ProductId': productId,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'description': description,
      'color': color,
      'quantity': quantity,
      'available': available,
      'sold': sold,
      'size': size,
      'supplierName': supplierName,
      'photos': photos,
    };
  }
}
