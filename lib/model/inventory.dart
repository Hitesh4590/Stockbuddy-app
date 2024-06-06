import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  String id;
  double buyPrice;
  List<String> colors;
  String date;
  String description;
  List<String> photos;
  double profitPerUnit;
  int quantity;
  double sellPrice;
  double sellPricePerUnit;
  String size;
  String skuNo;
  String supplierName;
  String title;
  String type;

  InventoryItem({
    required this.id,
    required this.buyPrice,
    required this.colors,
    required this.date,
    required this.description,
    required this.photos,
    required this.profitPerUnit,
    required this.quantity,
    required this.sellPrice,
    required this.sellPricePerUnit,
    required this.size,
    required this.skuNo,
    required this.supplierName,
    required this.title,
    required this.type,
  });

  // Convert an InventoryItem object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'buy_price': buyPrice,
      'colors': colors,
      'date': date,
      'description': description,
      'photos': photos,
      'profit_per_unit': profitPerUnit,
      'quantity': quantity,
      'sell_price': sellPrice,
      'sell_price_per_unit': sellPricePerUnit,
      'size': size,
      'sku_no': skuNo,
      'supplier_name': supplierName,
      'title': title,
      'type': type,
    };
  }

  // Extract an InventoryItem object from a DocumentSnapshot
  factory InventoryItem.fromDocument(DocumentSnapshot doc) {
    return InventoryItem(
      id: doc.id,
      buyPrice: doc['buy_price'],
      colors: List<String>.from(doc['colors']),
      date: doc['date'],
      description: doc['description'],
      photos: List<String>.from(doc['photos']),
      profitPerUnit: doc['profit_per_unit'],
      quantity: doc['quantity'],
      sellPrice: doc['sell_price'],
      sellPricePerUnit: doc['sell_price_per_unit'],
      size: doc['size'],
      skuNo: doc['sku_no'],
      supplierName: doc['supplier_name'],
      title: doc['title'],
      type: doc['type'],
    );
  }
}
