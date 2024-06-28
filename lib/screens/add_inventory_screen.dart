import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/util/validators.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/common/widget/upload_image_widget.dart';
import 'package:stockbuddy_flutter_app/local_packages/dropdown_textfield-master/lib/dropdown_textfield.dart';
import 'package:stockbuddy_flutter_app/providers/add_inventory_provider.dart';
import 'package:stockbuddy_flutter_app/screens/database_service.dart';
import 'package:stockbuddy_flutter_app/services/ad_service.dart';

import '../common/theme/color_constants.dart' as color;
import '../common/theme/text_styles.dart';
import '../model/product.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  SingleValueDropDownController sizeController =
      SingleValueDropDownController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AddInventoryProvider>(context, listen: false);
    provider.fetchAttribute();
  }

  @override
  Widget build(BuildContext context) {
    final AdService adService = AdService();
    final provider = context.watch<AddInventoryProvider>();
    return Scaffold(
      bottomNavigationBar: adService.getBannerAdWidget(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            iconSize: 16,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text(
          'Add Inventory',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Inventory Details',
              style: TextStyles.bold(fontSize: 14),
            ),
            20.vs,
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextFormFields(
                      hint: 'Title',
                      controller: titleController,
                      validator: (value) {
                        if (!Validators().isValidateField(value)) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                    20.vs,
                    AppTextFormFields.multiline(
                      hint: 'Description',
                      controller: descriptionController,
                      validator: (value) {
                        if (!Validators().isValidateField(value)) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    20.vs,
                    AppTextFormFields(
                      hint: 'Type',
                      controller: typeController,
                      validator: (value) {
                        if (!Validators().isValidateField(value)) {
                          return 'Please enter type';
                        }
                        return null;
                      },
                    ),
                    20.vs,
                    AppTextFormFields(
                      hint: 'Supplier Name',
                      controller: supplierController,
                      validator: (value) {
                        if (!Validators().isValidateField(value)) {
                          return 'Please enter supplier name';
                        }
                        return null;
                      },
                    ),
                    20.vs,
                    Text(
                      'Photo Upload',
                      style: TextStyles.bold(fontSize: 14),
                    ),
                    Text(
                      'Please upload inventory image with maximum size 4MB or less',
                      style: TextStyles.regular(fontSize: 10),
                    ),
                    SizedBox(
                      height: 102,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: UploadImageWidget(
                                  provider: provider, index: index),
                            );
                          }).allp(10),
                    ),
                    Text(
                      'Add Inventory Variants',
                      style: TextStyles.bold(fontSize: 14),
                    ),
                    20.vs,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropDownTextField(
                            hintText: 'Select Size',
                            clearOption: true,
                            enableSearch: true,
                            controller: sizeController,
                            searchDecoration: const InputDecoration(
                                hintText: 'Select Size',
                                prefixIcon: Icon(Icons.search_outlined)),
                            validator: (value) {
                              if (value == null) {
                                return 'please enter size';
                              } else {
                                return null;
                              }
                            },
                            dropDownItemCount: 4,
                            dropDownList: provider.dropDownList,
                          ),
                        ),
                        5.hs,
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              color: const Color(0xfff1f1f1),
                              borderRadius: BorderRadius.circular(15)),
                          child: const Icon(
                            Icons.add,
                            color: color.ColorConstants.lightGrey,
                          ).allp(8).onTap(() => addSize(context, provider)),
                        )
                      ],
                    ),
                    20.vs,
                    AppTextFormFields.intOnly(
                      hint: 'Quantity',
                      controller: quantityController,
                      validator: (value) {
                        if (!Validators().isValidateField(value)) {
                          return 'Please enter quantity ';
                        }
                        return null;
                      },
                    ),
                    20.vs,
                    Text(
                      'Select Color',
                      style: TextStyles.regularBlack(
                        fontSize: 12,
                      ),
                    ),
                    10.vs,
                    Row(
                      children: [
                        Wrap(
                          children: provider.color.map((colorString) {
                            bool isSelected =
                                provider.selectedColor == colorString;
                            return Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(int.parse(colorString, radix: 16)),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                      ),
                                    )
                                  : null,
                            ).onTap(
                              () {
                                provider.toggleColor(colorString);
                              },
                            ).rp(10);
                          }).toList(),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: color.ColorConstants.lightGrey,
                                  width: 1)),
                          child: SvgPicture.asset(ImageConstants.colorPicker)
                              .allp(5),
                        ).onTap(() => colorPickerDialog(context, provider))
                      ],
                    ),
                    20.vs,
                    Text(
                      'Add Inventory Price',
                      style: TextStyles.bold(fontSize: 14),
                    ),
                    20.vs,
                    AppTextFormFields.intOnly(
                      hint: 'Selling Price Per Unit',
                      controller: sellingPriceController,
                      validator: (value) {
                        if (!Validators().isValidateField(value)) {
                          return 'Please enter selling price';
                        }
                        return null;
                      },
                    ),
                    20.vs,
                    AppTextFormFields.intOnly(
                      hint: 'Purchase Price Per Unit',
                      controller: purchasePriceController,
                      validator: (value) {
                        if (!Validators().isValidateField(value)) {
                          return 'Please enter purchase price';
                        }
                        return null;
                      },
                    ),
                    Text(
                      '**Note :add the price concessional Tax',
                      style: TextStyles.regular(fontSize: 10),
                    )
                  ],
                )),
            20.vs,
            AppButton(
                isLoading: provider.isLoading,
                labelStyle: TextStyles.bold(color: Colors.white, fontSize: 16),
                labelText: 'Save',
                onTap: () async {
                  List<XFile> images = [];
                  if (provider.images[0] != null) {
                    images.add(provider.images[0]!);
                  }
                  if (provider.images[1] != null) {
                    images.add(provider.images[1]!);
                  }
                  if (provider.images[2] != null) {
                    images.add(provider.images[2]!);
                  }

                  if (_formKey.currentState!.validate()) {
                    provider.changeLoading(true);
                    String color = provider.selectedColor;

                    List<String> photos =
                        await DatabaseService().uploadImages(images);
                    int quantity = int.parse(quantityController.text);
                    double buyPrice =
                        double.parse(purchasePriceController.text);
                    double sellPrice =
                        double.parse(sellingPriceController.text);
                    final existingProduct = await provider
                        .getProductByTitle(titleController.text.trim());
                    String sku =
                        '${titleController.text}-${sizeController.dropDownValue?.value}-$color';

                    if (existingProduct != null) {
                      if (await provider.getProductDetailsBySku(
                          existingProduct.productId, sku)) {
                        final batchId = await provider.getTotalBatch(
                                existingProduct.productId, sku) +
                            1;
                        final newBatch = ProductBatch(
                            date: DateTime.now(),
                            supplierName: supplierController.text.toString(),
                            sellPrice: sellPrice,
                            buyPrice: buyPrice,
                            quantity: quantity,
                            available: quantity,
                            batchId: batchId);
                        await provider.addBatch(
                            existingProduct.productId, sku, newBatch);
                        await provider.clearImageList();
                        provider.changeLoading(false);
                        Navigator.pop(context);
                      } else {
                        provider.changeLoading(true);
                        final newProductDetail = ProductDetail(
                          title: existingProduct.title,
                          type: existingProduct.type,
                          inStock: quantity,
                          color: color,
                          size:
                              sizeController.dropDownValue?.value.toString() ??
                                  '',
                          photos: photos,
                          description: descriptionController.text.trim(),
                          sku: sku,
                          batches: [
                            ProductBatch(
                                date: DateTime.now(),
                                supplierName: supplierController.text,
                                batchId: 1,
                                quantity: quantity,
                                available: quantity,
                                buyPrice: buyPrice,
                                sellPrice: sellPrice)
                          ],
                        );
                        await provider.addProductDetail(
                            existingProduct.productId, newProductDetail);
                        await provider.clearImageList();
                        provider.changeLoading(false);
                        Navigator.pop(context);
                      }
                    } else {
                      provider.changeLoading(true);
                      int newProductId = await provider.getTotalProducts() + 1;
                      final newProduct = Product(
                          productId: newProductId,
                          title: titleController.text.trim(),
                          type: typeController.text.trim(),
                          productDetails: [
                            ProductDetail(
                                title: titleController.text.trim(),
                                type: typeController.text.trim(),
                                sku: sku,
                                size: sizeController.dropDownValue?.value,
                                color: color,
                                inStock: quantity,
                                description: descriptionController.text.trim(),
                                photos: photos,
                                batches: [
                                  ProductBatch(
                                      available: quantity,
                                      quantity: quantity,
                                      buyPrice: buyPrice,
                                      sellPrice: sellPrice,
                                      supplierName:
                                          supplierController.text.trim(),
                                      date: DateTime.now(),
                                      batchId: 1)
                                ])
                          ]);
                      await provider.addProduct(newProduct);
                      await provider.clearImageList();
                      provider.changeLoading(false);
                      Navigator.pop(context);
                    }
                  }
                }),
          ],
        ).allp(20),
      ),
    );
  }
}

Future<void> addSize(
    BuildContext context, AddInventoryProvider provider) async {
  final addSizeController = TextEditingController();
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
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
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ).onTap(() {
                      Navigator.pop(context);
                    }),
                  ),
                ),
                20.vs,
                Center(
                  child: Form(
                    key: _formkey1,
                    child: Column(
                      children: [
                        AppTextFormFields(
                          hint: 'Enter Size to Add',
                          controller: addSizeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please enter size';
                            }
                            return null;
                          },
                        ),
                        38.vs,
                        AppButton(
                            labelStyle: TextStyles.bold(
                                color: Colors.white, fontSize: 16),
                            labelText: 'Add',
                            onTap: () async {
                              if (_formkey1.currentState?.validate() ?? false) {
                                await provider
                                    .addSize(addSizeController.text.trim());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('size added successfully'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            }),
                        20.vs,
                      ],
                    ).allp(10),
                  ),
                ),
              ]),
        );
      });
}

Future<bool> colorPickerDialog(
    BuildContext context, AddInventoryProvider provider) async {
  Color selectedColor = Colors.blue;
  Future<void> handleOkButton(Color color) async {
    await provider.changeColor(color);
    await provider.addColor();
  }

  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Select color',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            onColorChanged: (Color color) {
              selectedColor = color;
            },
            width: 40,
            height: 40,
            borderRadius: 4,
            spacing: 5,
            runSpacing: 5,
            wheelDiameter: 155,
            heading: Text(
              'Select color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subheading: Text(
              'Select color shade',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            wheelSubheading: Text(
              'Selected color and its shades',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            showMaterialName: true,
            showColorName: true,
            showColorCode: true,
            copyPasteBehavior: const ColorPickerCopyPasteBehavior(
              longPressMenu: true,
            ),
            materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
            colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
            colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
            colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
            selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.both: false,
              ColorPickerType.primary: true,
              ColorPickerType.accent: true,
              ColorPickerType.bw: false,
              ColorPickerType.custom: true,
              ColorPickerType.wheel: true,
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
          ),
        ],
      );
    },
  ).then((value) {
    if (value ?? false) {
      handleOkButton(selectedColor);
      return true;
    }
    return false;
  });
}
