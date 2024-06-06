import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/common/widget/inventory_list_tile.dart';
import 'package:stockbuddy_flutter_app/model/inventory.dart';
import 'package:stockbuddy_flutter_app/providers/inventory_list_provider.dart';
import 'package:stockbuddy_flutter_app/screens/add_inventory_screen.dart';
import 'package:stockbuddy_flutter_app/screens/inventory_details_screen.dart';
import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';
import '../common/widget/border_button.dart';

class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({super.key});

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<InventoryListProvider>(context, listen: false);
    provider.fetchInventory();
  }

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
    final provider = context.watch<InventoryListProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text(
          'Inventory',
          style: TextStyles.regular_black(fontSize: 16),
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddInventoryScreen()));
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
                  onChanged: (value) {
                    provider.queryChanged(value);
                  },
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
                            provider.fetchInventory();
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
            20.vs,
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: provider.inventory.length,
              itemBuilder: (context, index) {
                InventoryItem item = provider.inventory[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InventoryDetailsScreen(
                                    skuNo: item.skuNo,
                                    title: item.title,
                                    type: item.type,
                                    sellingPrice: item.sellPrice,
                                    purchasePrice: item.buyPrice,
                                    description: item.description,
                                    images: item.photos,
                                    quantity: item.quantity,
                                    supplierName: item.supplierName,
                                  )));
                    },
                    child: InventoryListTile(
                        sku: item.skuNo,
                        image: item.photos[0],
                        title: item.title,
                        quantity: item.quantity,
                        type: item.type,
                        price: item.buyPrice),
                  ),
                );
              },
            ),
          ],
        ).allp(20),
      ),
    );
  }
}
