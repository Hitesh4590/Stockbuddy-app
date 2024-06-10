import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/providers/orders_screen_provider.dart';
import 'package:stockbuddy_flutter_app/screens/new_order_screen.dart';
import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';
import '../common/widget/app_textfield.dart';
import '../common/widget/border_button.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final GlobalKey _filterButtonGlobalKey = GlobalKey();
  RelativeRect _calculateMenuPosition() {
    final RenderBox button =
        _filterButtonGlobalKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(_filterButtonGlobalKey.currentContext!)
        .context
        .findRenderObject() as RenderBox;
    final Offset buttonOffset = button.localToGlobal(Offset.zero);
    return RelativeRect.fromRect(
      Rect.fromLTWH(
        buttonOffset.dx,
        buttonOffset.dy,
        button.size.width,
        button.size.height,
      ),
      Offset.zero & overlay.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersScreenProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: SvgPicture.asset(
          ImageConstants.drawer,
          fit: BoxFit.scaleDown,
        ).onTap(
          () => {},
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Orders',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
        actions: [
          GestureDetector(
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ).allp(5),
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewOrderScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: AppTextFormFields(
                  onChanged: (value) {},
                  prefixIcon: ImageConstants.search,
                )),
                10.hs,
                BorderButton(
                  isDisabled: true,
                  key: _filterButtonGlobalKey,
                  suffixImage: SvgPicture.asset(
                    ImageConstants.filter,
                    fit: BoxFit.fitWidth,
                  ),
                  title: '',
                  onTap: () {
                    showMenu(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: ColorConstants.lightGrey, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                      context: context,
                      items: List.generate(provider.filterPopupMenus().length,
                          (index) {
                        final selectedValue = provider.selectedFilter;
                        final listItemTitle =
                            provider.filterPopupMenus()[index].title;
                        final isItemSelected = listItemTitle == selectedValue;

                        final menuList = provider.filterPopupMenus(
                            isSelected: isItemSelected)[index];
                        return PopupMenuItem(
                          child: menuList,
                          onTap: () {
                            provider.setSelectedFilter(
                                provider.filterPopupMenus()[index].title);
                          },
                        );
                      }),
                      position: _calculateMenuPosition(),
                    );
                  },
                  height: 48,
                  spacingVertical: 12,
                  spacingHorizontal: 12,
                ),
              ],
            ),
          ],
        ).allp(20),
      ),
    );
  }
}
