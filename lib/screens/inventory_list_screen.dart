import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/common/widget/inventory_list_tile.dart';
import 'package:stockbuddy_flutter_app/providers/inventory_list_provider.dart';
import 'package:stockbuddy_flutter_app/screens/add_inventory_screen.dart';
import 'package:stockbuddy_flutter_app/screens/edit_sku_screen.dart';
import 'package:stockbuddy_flutter_app/screens/sku_screen.dart';
import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';
import '../common/widget/border_button.dart';
import '../model/product.dart';

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
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inventory',
                style: TextStyles.regularBlack(fontSize: 16),
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset(ImageConstants.addButton),
              ).onTap(() async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddInventoryScreen()));
                provider.fetchInventory();
              })
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            5.vs,
            Row(
              children: [
                Expanded(
                    child: AppTextFormFields(
                  hint: 'Search Inventory',
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
            18.vs,
            provider.productDetails.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.productDetails.length,
                    itemBuilder: (context, index) {
                      final ProductDetail item = provider.productDetails[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Slidable(
                          endActionPane: ActionPane(
                            extentRatio: 0.35,
                            motion: const ScrollMotion(),
                            children: [
                              SizedBox(
                                child: Builder(
                                  builder: (context) {
                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditSkuScreen(
                                                            detail: item)));
                                            provider.fetchInventory();
                                          },
                                          splashColor: ColorConstants.darkGrey,
                                          child: Container(
                                            padding: EdgeInsets.zero,
                                            decoration: const BoxDecoration(
                                                color: ColorConstants.darkGrey),
                                            child: Center(
                                                child: SvgPicture.asset(
                                              ImageConstants.edit2,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      ColorConstants.orange,
                                                      BlendMode.srcIn),
                                            ).hp(18).vp(20)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            int batchTotal = 0;
                                            for (ProductBatch items
                                                in item.batches) {
                                              batchTotal += items.quantity;
                                            }
                                            if (item.inStock == batchTotal) {
                                              await provider
                                                  .deleteProductDetail(item);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Deleted Successfully'),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Cannot delete , items are sold from this sku'),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          },
                                          splashColor: ColorConstants.darkGrey,
                                          child: Container(
                                            padding: EdgeInsets.zero,
                                            decoration: const BoxDecoration(
                                                color: ColorConstants.orange),
                                            child: Center(
                                                child: SvgPicture.asset(
                                              ImageConstants.trash2,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      ColorConstants.darkGrey,
                                                      BlendMode.srcIn),
                                              fit: BoxFit.scaleDown,
                                            ).hp(18).vp(24)),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          child: InventoryListTile(
                            id: item.sku,
                            image: (item.photos.isNotEmpty)
                                ? item.photos[0]
                                : ImageConstants.backgroundImage,
                            title: item.title,
                            quantity: item.inStock,
                            type: item.type,
                          ).onTap(() async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SkuScreen(productItem: item)));
                            provider.fetchInventory();
                          }),
                        ),
                      );
                    },
                  )
                : const Center(child: Text(' No Data')),
          ],
        ).allp(16),
      ),
    );
  }
}
