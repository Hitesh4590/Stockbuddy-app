import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';

import '../theme/text_styles.dart';

class OrdersListTile extends StatelessWidget {
  const OrdersListTile({
    super.key,
    required this.orderId,
    required this.date,
    required this.customer,
    required this.supplier,
    required this.total,
    required this.quantity,
  });
  final int orderId;
  final String date;
  final String customer;
  final String supplier;
  final double total;
  final int quantity;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: ColorConstants.offWhite),
        ),
        child: Row(
          children: [
            Container(
              height: 92,
              width: 5,
              decoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  borderRadius: BorderRadius.circular(5)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID:${orderId}',
                  style: TextStyles.bold(fontSize: 14),
                ),
                Text(
                  'Placed On:${date} ',
                  style: TextStyles.medium(),
                ),
                Text('Customer:${customer} ', style: TextStyles.medium()),
                Text('Retailer:${supplier} ', style: TextStyles.medium()),
              ],
            ).allp(10),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '₹ ${total}',
                  style: TextStyles.bold(fontSize: 14),
                ),
                Text('No of items: ${quantity} '),
              ],
            )
          ],
        ).allp(5));
  }
}
