import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';

import '../common/theme/image_constants.dart';
import '../common/theme/text_styles.dart';
import '../common/widget/cart_item_tile.dart';
import '../model/order.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen(
      {super.key, required this.orderItem, required this.date});
  final Order orderItem;
  final String date;
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    List<OrderedProduct> orderProducts = [];
    for (OrderedProduct order in widget.orderItem.orderedProducts) {
      orderProducts.add(order);
    }

    final List<Map<String, dynamic>> flattenedBatchOrders = [];
    for (final orderedProduct in orderProducts) {
      for (final batchOrder in orderedProduct.batchOrders) {
        flattenedBatchOrders.add({
          'orderedProduct': orderedProduct,
          'batchOrder': batchOrder,
        });
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            iconSize: 16,
            padding: const EdgeInsets.all(0),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          'Order Details',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.vs,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: ColorConstants.offWhite)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Id: ${widget.orderItem.orderId}',
                          style: TextStyles.bold(
                              color: ColorConstants.darkGrey, fontSize: 14),
                        ),
                        2.vs,
                        RichText(
                          text: TextSpan(
                            text: 'Payment Mode: ',
                            style: TextStyles.regular(),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.orderItem.paymentMode,
                                  style: TextStyles.bold()),
                            ],
                          ),
                        ),
                        2.vs,
                        RichText(
                          text: TextSpan(
                            text: 'Retailer: ',
                            style: TextStyles.regular(),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.orderItem.retailerName,
                                  style: TextStyles.bold()),
                            ],
                          ),
                        ),
                      ]).vp(9).hp(15),
                  RichText(
                    text: TextSpan(
                      text: 'Placed On: ',
                      style: TextStyles.small(),
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.date,
                            style: TextStyles.bold(fontSize: 10)),
                      ],
                    ),
                  ).allp(6)
                ],
              ),
            ),
            10.vs,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: ColorConstants.offWhite)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Customer Name: ${widget.orderItem.customerName}',
                    style: TextStyles.bold(
                        color: ColorConstants.darkGrey, fontSize: 14),
                  ),
                  2.vs,
                  RichText(
                    text: TextSpan(
                      text: 'Mobile No: ',
                      style: TextStyles.medium(),
                      children: <TextSpan>[
                        TextSpan(
                            text: '+91${widget.orderItem.customerPhone}',
                            style: TextStyles.bold(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ).allp(15),
            ),
            16.vs,
            Text('Product Details',
                style: TextStyles.medium(color: ColorConstants.darkGrey)),
            16.vs,
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: flattenedBatchOrders.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> batchOrderMap =
                      flattenedBatchOrders[index];
                  final OrderedProduct orderedProduct =
                      batchOrderMap['orderedProduct'];
                  final ProductBatchOrder batchOrder =
                      batchOrderMap['batchOrder'];

                  return CartItemTile(
                    image:
                        orderedProduct.photos ?? ImageConstants.backgroundImage,
                    sku: orderedProduct.sku,
                    title: orderedProduct.title,
                    size: orderedProduct.sku,
                    supplierName: batchOrder.supplierName,
                    price: batchOrder.price,
                    quantity: batchOrder.quantity,
                  ).bp(16);
                }),
            16.vs,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: ColorConstants.offWhite)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Order Details: ${widget.orderItem.customerName}',
                    style: TextStyles.bold(
                        color: ColorConstants.darkGrey, fontSize: 14),
                  ),
                  2.vs,
                  RichText(
                    text: TextSpan(
                      text: 'Total Price: ',
                      style: TextStyles.medium(),
                      children: <TextSpan>[
                        TextSpan(
                            text: '${widget.orderItem.totalAmount}',
                            style: TextStyles.bold(fontSize: 14)),
                      ],
                    ),
                  ),
                  2.vs,
                  RichText(
                    text: TextSpan(
                      text: 'Total Items: ',
                      style: TextStyles.medium(),
                      children: <TextSpan>[
                        TextSpan(
                            text: '${widget.orderItem.totalItems}',
                            style: TextStyles.bold(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ).allp(15),
            ),
          ],
        ).allp(16),
      ),
    );
  }
}
