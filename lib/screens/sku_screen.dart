import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/inventory_list_tile.dart';
import 'package:stockbuddy_flutter_app/model/product.dart';
import 'package:stockbuddy_flutter_app/screens/inventory_details_screen.dart';

import '../common/theme/text_styles.dart';

class SkuScreen extends StatefulWidget {
  const SkuScreen({super.key, required this.productItem});
  final ProductDetail productItem;
  @override
  State<SkuScreen> createState() => _SkuScreenState();
}

class _SkuScreenState extends State<SkuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              iconSize: 16,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.productItem.sku}'s batches",
                style: TextStyles.regularBlack(fontSize: 16),
              ),
            ],
          )),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            (widget.productItem.batches.isNotEmpty)
                ? SizedBox(
                    height: widget.productItem.batches.length * 200,
                    child: ListView.builder(
                        itemCount: widget.productItem.batches.length ?? 0,
                        itemBuilder: (context, index) {
                          final ProductBatch item =
                              widget.productItem.batches[index];
                          return InventoryListTile(
                            id: item.batchId.toString(),
                            image: widget.productItem.photos.isNotEmpty
                                ? widget.productItem.photos[0]
                                : ImageConstants.backgroundImage,
                            title: widget.productItem.title,
                            quantity: item.available,
                            type: widget.productItem.type,
                            price: item.sellPrice,
                            batch: true,
                          ).bp(16).onTap(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InventoryDetailsScreen(
                                            detail: widget.productItem,
                                            batch: item)));
                          });
                        }))
                : Center(child: Text('No Data')),
          ],
        ).allp(16),
      ),
    );
  }
}
