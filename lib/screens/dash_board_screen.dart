import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';
import 'package:stockbuddy_flutter_app/screens/add_company_screen.dart';
import 'package:stockbuddy_flutter_app/screens/channel_screen.dart';
import 'package:stockbuddy_flutter_app/screens/home_screen.dart';
import 'package:stockbuddy_flutter_app/screens/inventory_list_screen.dart';
import 'package:stockbuddy_flutter_app/screens/order_details_screen.dart';
import 'package:stockbuddy_flutter_app/screens/orders_screen.dart';
import 'package:stockbuddy_flutter_app/screens/profile_screen.dart';

import '../common/theme/image_constants.dart';

class DashBoardScreen extends StatelessWidget {
  List<Widget> pages = [
    HomeScreen(),
    OrdersScreen(),
    InventoryListScreen(),
    ChannelScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToggleProvider>();
    return Scaffold(
      body: pages[provider.selectedScreen],
      bottomNavigationBar: ConvexAppBar(
        elevation: 14,
        shadowColor: Colors.black.withOpacity(0.25),
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.black,
        activeColor: Colors.orange,
        style: TabStyle.fixedCircle,
        items: [
          TabItem(
              title: provider.selectedScreen == 0 ? 'Home' : '',
              icon: provider.selectedScreen == 0
                  ? SvgPicture.asset(ImageConstants.homeSelected)
                  : SvgPicture.asset(ImageConstants.home)),
          TabItem(
              title: provider.selectedScreen == 1 ? 'Order' : '',
              icon: provider.selectedScreen == 1
                  ? SvgPicture.asset(ImageConstants.orderSelected)
                  : SvgPicture.asset(ImageConstants.order)),
          TabItem(
              icon: SvgPicture.asset(
            ImageConstants.inventory,
            fit: BoxFit.scaleDown,
          )),
          TabItem(
              title: provider.selectedScreen == 3 ? 'Channel' : '',
              icon: provider.selectedScreen == 3
                  ? SvgPicture.asset(ImageConstants.channelSelected)
                  : SvgPicture.asset(ImageConstants.channel)),
          TabItem(
              title: provider.selectedScreen == 4 ? 'Profile' : '',
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
