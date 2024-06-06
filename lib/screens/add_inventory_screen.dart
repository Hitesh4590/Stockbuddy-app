import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/util/validators.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/common/widget/color_selection.dart';
import 'package:stockbuddy_flutter_app/local_packages/dropdown_textfield-master/lib/dropdown_textfield.dart';
import 'package:stockbuddy_flutter_app/model/inventory.dart';
import 'package:stockbuddy_flutter_app/providers/add_inventory_provider.dart';
import 'package:stockbuddy_flutter_app/screens/database_service.dart';
import '../common/theme/color_constants.dart' as color;
import '../common/theme/text_styles.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController skuController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  SingleValueDropDownController sizeController =
      SingleValueDropDownController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddInventoryProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text(
          'Add Inventory',
          style: TextStyles.regular_black(fontSize: 16),
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
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormFields(
                            controller: skuController,
                            hint: 'SKU NO',
                            validator: (value) {
                              if (!Validators().isValidateField(value)) {
                                return 'Please enter sku no';
                              }
                              return null;
                            },
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
                    20.vs,
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
                        if (value!.length < 100) {
                          return 'Please enter atleast 100 charaters';
                        }
                        if (value.length > 255) {
                          return 'Please enter 255 charaters only';
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
                          return 'Please enter sku no';
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
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await _getImage();
                            provider.addImage(imageXFile!, 0);
                            provider.addImageError();
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F1F1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: provider.image1 == null
                                    ? SvgPicture.asset(
                                        ImageConstants.uploadImage,
                                        fit: BoxFit.contain,
                                      ).allp(10)
                                    : Image.file(
                                        File(provider.image1!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              if (provider.image1 != null)
                                Positioned(
                                  left: 52,
                                  child: InkWell(
                                    child: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      backgroundColor: Colors.white,
                                      child: SvgPicture.asset(
                                          ImageConstants.cancelImage),
                                    ),
                                    onTap: () {
                                      provider.removeImage(0);
                                      provider.addImageError();
                                    },
                                  ),
                                )
                            ],
                          ),
                        ),
                        10.hs,
                        InkWell(
                          onTap: () async {
                            await _getImage();
                            provider.addImage(imageXFile!, 1);
                            provider.addImageError();
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F1F1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: provider.image2 == null
                                    ? SvgPicture.asset(
                                        ImageConstants.uploadImage,
                                        fit: BoxFit.contain,
                                      ).allp(10)
                                    : Image.file(
                                        File(provider.image2!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              if (provider.image2 != null)
                                Positioned(
                                  left: 52,
                                  child: InkWell(
                                    child: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      backgroundColor: Colors.white,
                                      child: SvgPicture.asset(
                                          ImageConstants.cancelImage),
                                    ),
                                    onTap: () {
                                      provider.removeImage(1);
                                      provider.addImageError();
                                    },
                                  ),
                                )
                            ],
                          ),
                        ),
                        10.hs,
                        InkWell(
                          onTap: () async {
                            await _getImage();
                            provider.addImage(imageXFile!, 2);
                            provider.addImageError();
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F1F1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: provider.image3 == null
                                    ? SvgPicture.asset(
                                        ImageConstants.uploadImage,
                                        fit: BoxFit.contain,
                                      ).allp(10)
                                    : Image.file(
                                        File(provider.image3!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              if (provider.image3 != null)
                                Positioned(
                                  left: 52,
                                  child: InkWell(
                                    child: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.028,
                                      backgroundColor: Colors.white,
                                      child: SvgPicture.asset(
                                          ImageConstants.cancelImage),
                                    ),
                                    onTap: () {
                                      provider.removeImage(2);
                                      provider.addImageError();
                                    },
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ).allp(10),
                    Text(
                      provider.errorText,
                      style:
                          TextStyles.regular(color: Colors.red, fontSize: 12),
                    ),
                    Text(
                      'Add Inventory Variants',
                      style: TextStyles.bold(fontSize: 14),
                    ),
                    20.vs,
                    DropDownTextField(
                      clearOption: true,
                      enableSearch: true,
                      controller: sizeController,
                      searchDecoration: const InputDecoration(
                          hintText: "Select Size",
                          prefixIcon: Icon(Icons.search_outlined)),
                      validator: (value) {
                        if (value == null) {
                          return "please enter size";
                        } else {
                          return null;
                        }
                      },
                      dropDownItemCount: 5,
                      dropDownList: const [
                        DropDownValueModel(name: 'S', value: "S"),
                        DropDownValueModel(name: 'M', value: "M"),
                        DropDownValueModel(name: 'L', value: "L"),
                        DropDownValueModel(name: 'XL', value: "XL"),
                        DropDownValueModel(name: 'XXL', value: "XXL"),
                      ],
                      onChanged: (val) {},
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
                      style: TextStyles.regular_black(
                        fontSize: 12,
                      ),
                    ),
                    10.vs,
                    Row(
                      children: [
                        GestureDetector(
                          child: ColorSelection(
                            color: Colors.red,
                            id: 0,
                            selectedColor: provider.selectedColor,
                          ),
                          onTap: () {
                            provider.toggleColor(0);
                          },
                        ),
                        10.hs,
                        GestureDetector(
                          child: ColorSelection(
                            color: Colors.grey,
                            id: 1,
                            selectedColor: provider.selectedColor,
                          ),
                          onTap: () {
                            provider.toggleColor(1);
                          },
                        ),
                        10.hs,
                        GestureDetector(
                          child: ColorSelection(
                            color: Color(0xffC58D02),
                            id: 2,
                            selectedColor: provider.selectedColor,
                          ),
                          onTap: () {
                            provider.toggleColor(2);
                          },
                        ),
                        10.hs,
                        GestureDetector(
                          child: ColorSelection(
                            color: Color(0xff005A8D),
                            id: 3,
                            selectedColor: provider.selectedColor,
                          ),
                          onTap: () {
                            provider.toggleColor(3);
                          },
                        ),
                        10.hs,
                        GestureDetector(
                          child: ColorSelection(
                            color: Color(0xffFF8A00),
                            id: 4,
                            selectedColor: provider.selectedColor,
                          ),
                          onTap: () {
                            provider.toggleColor(4);
                          },
                        ),
                      ],
                    ),
                    20.vs,
                    Text(
                      'Add Inventory Price',
                      style: TextStyles.bold(fontSize: 14),
                    ),
                    20.vs,
                    AppTextFormFields.intOnly(
                      hint: 'Selling Price',
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
                      hint: 'Purchase Price',
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
                labelText: 'Save',
                onTap: () async {
                  List<XFile> images = [];
                  if (provider.image1 != null) {
                    images.add(provider.image1!);
                  }
                  if (provider.image2 != null) {
                    images.add(provider.image2!);
                  }
                  if (provider.image3 != null) {
                    images.add(provider.image3!);
                  }

                  if (_formKey.currentState!.validate() &&
                      provider.errorText == '') {
                    List<String> color = [];
                    switch (provider.selectedColor) {
                      case 0:
                        color.clear();
                        color.add('red');
                        break;
                      case 1:
                        color.clear();
                        color.add('grey');
                        break;
                      case 2:
                        color.clear();
                        color.add('yellow');
                        break;
                      case 3:
                        color.clear();
                        color.add('blue');
                        break;
                      case 4:
                        color.clear();
                        color.add('orange');
                        break;
                    }

                    List<String> photos =
                        await DatabaseService().uploadImages(images);
                    int quantity = int.parse(quantityController.text.trim());
                    double sellPrice =
                        double.parse(sellingPriceController.text.trim());
                    double purchasePrice =
                        double.parse(purchasePriceController.text.trim());
                    double sellPricePerUnit = sellPrice / quantity;
                    double profitPerUnit =
                        sellPricePerUnit - (purchasePrice / quantity);
                    final inventory = InventoryItem(
                        id: '',
                        buyPrice: double.parse(purchasePriceController.text),
                        colors: color,
                        date: DateTime.now().toString(),
                        description: descriptionController.text,
                        photos: photos,
                        profitPerUnit: profitPerUnit,
                        quantity: quantity,
                        sellPrice: sellPrice,
                        sellPricePerUnit: sellPricePerUnit,
                        size: sizeController.dropDownValue?.name ?? "",
                        skuNo: skuController.text,
                        supplierName: supplierController.text,
                        title: titleController.text,
                        type: typeController.text);
                    await DatabaseService().addInventory(inventory);
                    Navigator.pop(context);
                  }
                }),
          ],
        ).allp(20),
      ),
    );
  }
}
