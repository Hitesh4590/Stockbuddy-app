import 'dart:core';
import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';

import '../theme/text_styles.dart';

class InventoryListTile extends StatelessWidget {
  final String sku;
  final String image;
  final String title;
  final int quantity;
  final String type;
  final double price;
  InventoryListTile({
    required this.sku,
    required this.image,
    required this.title,
    required this.quantity,
    required this.type,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 132,
        width: 343,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: Color(0xffEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SKU NO:$sku',
                  style: TextStyles.bold(),
                ),
                if (quantity > 0)
                  Container(
                    width: 68,
                    height: 24,
                    decoration: BoxDecoration(
                        color: Color(0xff4BAE4F).withOpacity(0.46),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'In-stock',
                      style: TextStyles.regular(color: Color(0xff38773B)),
                    ).hp(6).vp(3),
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
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
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
                            color: Colors.black,
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
                          style: TextStyles.regular_black(),
                        ),
                        Text(
                          'Type: $type',
                          style: TextStyles.regular_black(),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                if (quantity > 0)
                  Text(
                    '₹$price',
                    style: TextStyles.bold(fontSize: 14),
                  ),
              ],
            ),
          ],
        ).allp(5));
  }
}
