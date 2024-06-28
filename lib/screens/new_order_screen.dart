import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/common/widget/cart_item_tile.dart';
import 'package:stockbuddy_flutter_app/local_packages/dropdown_textfield-master/lib/dropdown_textfield.dart';
import 'package:stockbuddy_flutter_app/providers/new_order_provider.dart';
import '../common/theme/color_constants.dart' as color;
import '../common/theme/text_styles.dart';
import '../common/util/validators.dart';
import '../model/order.dart';
import '../services/ad_service.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SingleValueDropDownController skuController = SingleValueDropDownController();
  SingleValueDropDownController paymentModeController =
      SingleValueDropDownController();
  SingleValueDropDownController channelController =
      SingleValueDropDownController();
  final discountController = TextEditingController();
  final retailerController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewOrderProvider>().fetchInventory();
      context.read<NewOrderProvider>().fetchAttributes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AdService adService = AdService();
    final provider = context.watch<NewOrderProvider>();

    final List<Map<String, dynamic>> flattenedBatchOrders = [];
    for (final orderedProduct in provider.cart) {
      for (final batchOrder in orderedProduct.batchOrders) {
        flattenedBatchOrders.add({
          'orderedProduct': orderedProduct,
          'batchOrder': batchOrder,
        });
      }
    }
    double total = provider.cart.fold(
        0,
        (sum, item) =>
            sum +
            item.batchOrders.fold(0,
                (batchSum, batch) => batchSum + batch.quantity * batch.price));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            iconSize: 16,
            onPressed: () {
              provider.cart.clear();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text(
          'New Order',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            7.vs,
            SizedBox(
              height: flattenedBatchOrders.length * 116,
              child: provider.cart.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: flattenedBatchOrders.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> batchOrderMap =
                            flattenedBatchOrders[index];
                        final OrderedProduct orderedProduct =
                            batchOrderMap['orderedProduct'];
                        final ProductBatchOrder batchOrder =
                            batchOrderMap['batchOrder'];

                        return CartItemTile(
                          image: orderedProduct.photos ??
                              ImageConstants.backgroundImage,
                          sku: orderedProduct.sku,
                          title: orderedProduct.title,
                          size: orderedProduct.sku,
                          supplierName: batchOrder.supplierName,
                          price: batchOrder.price,
                          quantity: batchOrder.quantity,
                        ).bp(16);
                      })
                  : null,
            ),
            10.vs,
            Row(
              children: [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: Checkbox(
                    value: provider.discount,
                    onChanged: (bool? value) {},
                  ),
                ),
                10.hs,
                Text(
                  'Want to apply discount?',
                  style: TextStyles.regularBlack(),
                )
              ],
            ).onTap(() {
              provider.toggleDiscount();
            }),
            provider.discount ? 10.vs : 0.vs,
            provider.discount
                ? AppTextFormFields.intOnly(
                    hint: 'Enter Discount Value',
                    controller: discountController,
                    validator: (value) {
                      if (value == null) {
                        return 'enter discount value';
                      }
                      return null;
                    },
                  )
                : const SizedBox.shrink(),
            16.vs,
            Row(
              children: [
                Text(
                  'Total:',
                  style: TextStyles.bold(fontSize: 14),
                ),
                const Spacer(),
                Text(
                  total.toString(),
                  style: TextStyles.bold(fontSize: 14),
                )
              ],
            ),
            16.vs,
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Items',
                    style: TextStyles.bold(fontSize: 14),
                  ),
                  20.vs,
                  Row(
                    children: [
                      Expanded(
                        child: DropDownTextField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (val) => val != null
                              ? buildShowDialog(
                                  skuController.dropDownValue?.value, provider)
                              : null,
                          hintText: 'Select Sku',
                          clearOption: false,
                          enableSearch: true,
                          controller: skuController,
                          searchDecoration: const InputDecoration(
                              hintText: 'Select Sku',
                              prefixIcon: Icon(Icons.search_outlined)),
                          validator: (value) {
                            if (value == null) {
                              return 'please enter sku';
                            } else {
                              return null;
                            }
                          },
                          dropDownItemCount: 4,
                          dropDownList: provider.skuDropDownList,
                        ),
                      ),
                      10.hs,
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: color.ColorConstants.darkGrey,
                              border: Border.all(width: 1),
                            ),
                            child: SvgPicture.asset(ImageConstants.barcode)
                                .allp(10)),
                      ),
                    ],
                  ),
                  30.vs,
                  Text(
                    'Add Customer Info',
                    style: TextStyles.bold(fontSize: 14),
                  ),
                  20.vs,
                  AppTextFormFields(
                    controller: customerNameController,
                    hint: 'Name',
                    validator: (value) {
                      if (!Validators().isValidateField(value)) {
                        return 'Please enter customer name';
                      }
                      return null;
                    },
                  ),
                  16.vs,
                  AppTextFormFields.intOnly(
                      controller: phoneNoController,
                      hint: 'Mobile Number',
                      validator: (value) {
                        return Validators().validatePhoneNumber(value);
                      }),
                  30.vs,
                  Text(
                    'Additional Info',
                    style: TextStyles.bold(fontSize: 14),
                  ),
                  20.vs,
                  DropDownTextField(
                    controller: paymentModeController,
                    hintText: 'Select Payment mode',
                    clearOption: true,
                    enableSearch: false,
                    validator: (value) {
                      if (value == null) {
                        return 'please enter payment mode';
                      } else {
                        return null;
                      }
                    },
                    dropDownItemCount: 3,
                    dropDownList: const [
                      DropDownValueModel(name: 'Online', value: 'Online'),
                      DropDownValueModel(name: 'Offline', value: 'Offline'),
                    ],
                  ),
                  16.vs,
                  DropDownTextField(
                    controller: channelController,
                    hintText: 'Select Channel',
                    clearOption: true,
                    enableSearch: true,
                    searchDecoration: const InputDecoration(
                        hintText: 'Select Channel',
                        prefixIcon: Icon(Icons.search_outlined)),
                    validator: (value) {
                      if (value == null) {
                        return 'please enter Channel name';
                      } else {
                        return null;
                      }
                    },
                    dropDownItemCount: 3,
                    dropDownList: provider.allChannelDrop,
                  ),
                  16.vs,
                  AppTextFormFields(
                    controller: retailerController,
                    hint: 'Enter Retailer Name',
                    validator: (value) {
                      if (!Validators().isValidateField(value)) {
                        return 'Please enter retailer name';
                      }
                      return null;
                    },
                  ),
                  218.vs,
                  AppButton(
                      labelStyle:
                          TextStyles.bold(color: Colors.white, fontSize: 16),
                      labelText: 'Place Order',
                      isLoading: provider.isLoading,
                      onTap: () async {
                        int orderId = await provider.getTotalOrder() + 1;
                        if (_formKey.currentState!.validate()) {
                          provider.changeLoading(true);
                          final order = Order(
                            paymentMode:
                                paymentModeController.dropDownValue?.value ??
                                    '',
                            channel:
                                channelController.dropDownValue?.value ?? '',
                            orderId: orderId,
                            retailerName: retailerController.text,
                            customerName: customerNameController.text,
                            customerPhone: phoneNoController.text,
                            orderedProducts: provider.cart,
                            date: DateTime.now(),
                            totalAmount: provider.cart.fold(
                                0,
                                (sum, item) =>
                                    sum +
                                    item.batchOrders.fold(
                                        0,
                                        (batchSum, batch) =>
                                            batchSum +
                                            batch.quantity * batch.price)),
                          );
                          await provider.uploadOrder(order);
                          provider.cart.clear();
                          provider.changeLoading(false);
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            ),
          ],
        ).allp(16),
      ),
      bottomNavigationBar: adService.getBannerAdWidget().allp(16),
    );
  }

  Future<void> buildShowDialog(String sku, NewOrderProvider provider) async {
    await provider.getProductDetails(sku);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final sizeController = TextEditingController();
    final quantityController = TextEditingController();
    final orderPriceController = TextEditingController();
    sizeController.text = provider.product[0].size;

    double calculateTotalPrice(int quantity) {
      double totalPrice = 0;
      int remainingQuantity = quantity;

      for (var batch in provider.product[0].batches) {
        if (remainingQuantity <= 0) break;
        int usedQuantity = remainingQuantity > batch.available
            ? batch.available
            : remainingQuantity;
        totalPrice += usedQuantity * batch.sellPrice;
        remainingQuantity -= usedQuantity;
      }

      return totalPrice;
    }

    // Check if SKU already exists in the cart
    bool skuExistsInCart =
        provider.cart.any((orderedProduct) => orderedProduct.sku == sku);

    if (skuExistsInCart) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            contentPadding: const EdgeInsets.all(0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.vs,
                Text(
                  'Item is already in cart',
                  style: TextStyles.bold(fontSize: 14),
                ),
                40.vs,
                AppButton(
                  labelText: 'Close',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonWidth: 136,
                ),
              ],
            ).allp(18),
          );
        },
      );
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          contentPadding: const EdgeInsets.all(0),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          ImageConstants.cross,
                          height: 10,
                          width: 10,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn),
                        ).onTap(() {
                          Navigator.pop(context);
                        }),
                      ),
                    ),
                    20.vs,
                    Text(
                      'Add Order Variants',
                      style: TextStyles.bold(fontSize: 14),
                    ),
                    16.vs,
                    const Text('Color'),
                    10.vs,
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                            int.parse(provider.product[0].color, radix: 16)),
                      ),
                    ),
                    16.vs,
                    AppTextFormFields(
                      readOnly: true,
                      hint: 'Size',
                      controller: sizeController,
                    ),
                    16.vs,
                    AppTextFormFields.intOnly(
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            int quantity = int.tryParse(value) ?? 0;
                            double totalPrice = calculateTotalPrice(quantity);
                            orderPriceController.text =
                                totalPrice.toStringAsFixed(2);
                          } else {
                            orderPriceController.text = '';
                          }
                        });
                      },
                      hint: 'Quantity',
                      controller: quantityController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter quantity';
                        } else {
                          int? val = int.tryParse(value);
                          if (val == null ||
                              val < 1 ||
                              val > provider.product[0].inStock) {
                            return 'please enter within available quantity';
                          }
                          return null;
                        }
                      },
                    ),
                    Text(
                      'available quantity ${provider.product[0].inStock}',
                      style: TextStyles.small(),
                    ),
                    16.vs,
                    AppTextFormFields(
                      readOnly: true,
                      hint: 'Order Price',
                      controller: orderPriceController,
                    ),
                    40.vs,
                    AppButton(
                      labelText: 'Add',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          int quantity = int.parse(quantityController.text);
                          List<ProductBatchOrder> batchOrders = [];
                          int remainingQuantity = quantity;

                          for (var batch in provider.product[0].batches) {
                            if (remainingQuantity <= 0) break;
                            int usedQuantity =
                                remainingQuantity > batch.available
                                    ? batch.available
                                    : remainingQuantity;
                            batchOrders.add(ProductBatchOrder(
                              supplierName: batch.supplierName,
                              batchId: batch.batchId,
                              quantity: usedQuantity,
                              price: batch.sellPrice,
                            ));
                            remainingQuantity -= usedQuantity;
                          }
                          final cartItem = OrderedProduct(
                              sku: sku,
                              title: provider.product[0].title,
                              quantity: quantity,
                              batchOrders: batchOrders,
                              photos: provider.product[0].photos.isNotEmpty
                                  ? provider.product[0].photos[0]
                                  : null);

                          provider.addToCart(cartItem);
                          Navigator.pop(context);
                        }
                      },
                      buttonWidth: 136,
                    ),
                  ],
                ).allp(18),
              );
            },
          ),
        );
      },
    );
  }
}
