import 'dart:core';
import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';
import '../theme/text_styles.dart';

class CartItemTile extends StatelessWidget {
  final String image;
  final String sku;
  final String title;
  final String size;
  final String supplierName;
  final double price;
  final int quantity;
  CartItemTile({
    required this.image,
    required this.sku,
    required this.title,
    required this.size,
    required this.supplierName,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: ColorConstants.offWhite),
      ),
      child: Row(
        children: [
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: ClipRRect(
              child: Image.network(image),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sku:$sku',
                style: TextStyles.smallBlack(),
              ),
              Text(
                title,
                style: TextStyles.bold(fontSize: 14),
              ),
              Text(
                'Size: $size',
                style: TextStyles.small(),
              ),
              Text(
                'Supplier: $supplierName',
                style: TextStyles.small(),
              )
            ],
          ).hp(6).vp(4),
          const Spacer(),
          Column(
            children: [
              Text(
                '₹$price',
                style: TextStyles.regularBlack(fontSize: 14),
              ),
              Text(
                'Qty: $quantity',
                style: TextStyles.regularBlack(fontSize: 12),
              ),
            ],
          )
        ],
      ).vp(16).hp(10),
    );
  }
}
