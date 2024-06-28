import 'dart:core';
import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';
import '../theme/text_styles.dart';

class InventoryListTile extends StatelessWidget {
  final bool? batch;
  final String id;
  final String image;
  final String title;
  final int quantity;
  final String type;
  final double? price;
  InventoryListTile({
    this.batch,
    required this.id,
    required this.image,
    required this.title,
    required this.quantity,
    required this.type,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: ColorConstants.offWhite),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (batch ?? false)
                    ? Text(
                        'Batch: $id',
                        style: TextStyles.bold(),
                      )
                    : Text('Sku: $id'),
                if (quantity > 0)
                  Container(
                    width: 68,
                    height: 24,
                    decoration: BoxDecoration(
                        color:
                            ColorConstants.inventoryInStock.withOpacity(0.46),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'In-stock',
                      style: TextStyles.regular(
                          color: ColorConstants.inventoryInStockText),
                    ).hp(7).vp(3),
                  ),
              ],
            ),
            10.vs,
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 76,
                      width: 76,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.transparent, width: 0),
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (quantity == 0)
                      Positioned(
                        child: Container(
                          width: 76,
                          height: 76,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    if (quantity == 0)
                      Positioned(
                          top: 36,
                          child: Container(
                            width: 76,
                            height: 20,
                            color: ColorConstants.black,
                            child: Text(
                              'Out of stock',
                              style: TextStyles.regular(
                                  fontSize: 12, color: Colors.orange),
                            ),
                          ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    5.hs,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyles.bold(fontSize: 14),
                        ),
                        Text(
                          'Qty: $quantity',
                          style: TextStyles.regularBlack(),
                        ),
                        Text(
                          'Type: $type',
                          style: TextStyles.regularBlack(),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                if (quantity > 0)
                  if (batch ?? false)
                    Text(
                      '₹$price',
                      style: TextStyles.bold(fontSize: 14),
                    ),
              ],
            ),
          ],
        ).hp(10).vp(14));
  }
}
