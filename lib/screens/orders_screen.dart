import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/orders_list_tile.dart';
import 'package:stockbuddy_flutter_app/providers/orders_screen_provider.dart';
import 'package:stockbuddy_flutter_app/screens/new_order_screen.dart';
import 'package:stockbuddy_flutter_app/screens/order_details_screen.dart';
import '../common/theme/text_styles.dart';
import '../common/widget/app_textfield.dart';
import '../model/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersScreenProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersScreenProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Orders',
                style: TextStyles.regularBlack(fontSize: 16),
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset(ImageConstants.addButton),
              ).onTap(() async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewOrderScreen()));
                provider.fetchOrders();
              })
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: AppTextFormFields(
                  hint: 'Search Orders',
                  onChanged: (value) {
                    provider.queryChanged(value);
                  },
                  prefixIcon: ImageConstants.search,
                )),
              ],
            ),
            20.vs,
            SizedBox(
              width: double.infinity,
              height: provider.allOrders.length * 200,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.allOrders.length,
                  itemBuilder: (context, index) {
                    final Order item = provider.allOrders[index];
                    String formatDate(DateTime date) {
                      final DateFormat formatter = DateFormat('d MMM yy');
                      return formatter.format(date);
                    }

                    final String date = formatDate(item.date);
                    return OrdersListTile(
                            orderId: item.orderId,
                            date: date,
                            customer: item.customerName,
                            supplier: item.retailerName,
                            total: item.totalAmount,
                            quantity: item.totalItems)
                        .onTap(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetailsScreen(
                                    orderItem: provider.allOrders[index],
                                    date: date,
                                  )));
                    }).bp(16);
                  }),
            )
          ],
        ).allp(20),
      ),
    );
  }
}
