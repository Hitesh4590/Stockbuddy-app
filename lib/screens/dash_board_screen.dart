import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';
import 'package:stockbuddy_flutter_app/screens/add_company_screen.dart';
import 'package:stockbuddy_flutter_app/screens/add_inventory_screen.dart';
import 'package:stockbuddy_flutter_app/screens/channel_screen.dart';
import 'package:stockbuddy_flutter_app/screens/forgot_password_screen.dart';
import 'package:stockbuddy_flutter_app/screens/home_screen.dart';
import 'package:stockbuddy_flutter_app/screens/inventory_details_screen.dart';
import 'package:stockbuddy_flutter_app/screens/inventory_list_screen.dart';
import 'package:stockbuddy_flutter_app/screens/orders_screen.dart';

import '../common/theme/image_constants.dart';

class DashBoardScreen extends StatelessWidget {
  List<Widget> pages = [
    HomeScreen(),
    OrdersScreen(),
    InventoryListScreen(),
    ChannelScreen(),
    AddCompanyScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToggleProvider>();
    return Scaffold(
      body: pages[provider.selectedScreen],
      bottomNavigationBar: ConvexAppBar(
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.black,
        activeColor: Colors.orange,
        style: TabStyle.fixedCircle,
        items: [
          TabItem(
              icon: provider.selectedScreen == 0
                  ? SvgPicture.asset(ImageConstants.homeSelected)
                  : SvgPicture.asset(ImageConstants.home)),
          TabItem(
              icon: provider.selectedScreen == 1
                  ? SvgPicture.asset(ImageConstants.orderSelected)
                  : SvgPicture.asset(ImageConstants.order)),
          TabItem(
              icon: SvgPicture.asset(
            ImageConstants.inventory,
            fit: BoxFit.scaleDown,
          )),
          TabItem(
              icon: provider.selectedScreen == 3
                  ? SvgPicture.asset(ImageConstants.channelSelected)
                  : SvgPicture.asset(ImageConstants.channel)),
          TabItem(
              icon: provider.selectedScreen == 4
                  ? SvgPicture.asset(ImageConstants.profileSelected)
                  : SvgPicture.asset(ImageConstants.profile)),
        ],
        initialActiveIndex: 1,
        onTap: (int i) {
          provider.changeScreen(i);
        },
      ),
    );
  }
}
