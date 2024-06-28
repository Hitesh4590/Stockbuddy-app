import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/widget/inventory_list_tile.dart';
import 'package:stockbuddy_flutter_app/model/product.dart';

class InventoryBatchesScreen extends StatefulWidget {
  const InventoryBatchesScreen({super.key, required this.detail});

  final ProductDetail detail;

  @override
  State<InventoryBatchesScreen> createState() => _InventoryBatchesScreenState();
}

class _InventoryBatchesScreenState extends State<InventoryBatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [Text('${widget.detail.sku} batches')],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                itemCount: widget.detail.batches.length,
                itemBuilder: (context, index) {
                  ProductBatch item = widget.detail.batches[index];
                  return InventoryListTile(
                    id: item.batchId.toString(),
                    image: widget.detail.photos[0],
                    title: widget.detail.title,
                    quantity: item.available,
                    type: widget.detail.type,
                    price: item.sellPrice,
                    batch: true,
                  );
                })
          ],
        ).allp(16),
      ),
    );
  }
}
