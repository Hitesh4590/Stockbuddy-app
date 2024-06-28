import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/providers/inventory_details_provider.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';

import '../common/theme/text_styles.dart';
import '../common/util/validators.dart';
import '../common/widget/app_button.dart';
import '../model/product.dart';
import 'dash_board_screen.dart';

class EditBatchScreen extends StatefulWidget {
  const EditBatchScreen({super.key, required this.detail, required this.batch});
  final ProductDetail detail;
  final ProductBatch batch;

  @override
  State<EditBatchScreen> createState() => _EditBatchScreenState();
}

class _EditBatchScreenState extends State<EditBatchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final sellPriceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final supplierController = TextEditingController();
  @override
  void initState() {
    super.initState();
    sellPriceController.text = widget.batch.sellPrice.toString();
    purchasePriceController.text = widget.batch.buyPrice.toString();
    supplierController.text = widget.batch.supplierName.toString();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<InventoryDetailsProvider>();
    return Scaffold(
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
          'Edit Batch',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            12.vs,
            AppTextFormFields(
                label: 'Supplier Name',
                hint: 'Supplier Name',
                controller: supplierController,
                validator: (value) {
                  if (!Validators().isValidateField(value)) {
                    return 'Please enter supplier name';
                  }
                  return null;
                }),
            16.vs,
            AppTextFormFields.intOnly(
              hint: 'Selling Price',
              label: 'Selling Price',
              controller: sellPriceController,
              validator: (value) {
                if (!Validators().isValidateField(value)) {
                  return 'Please enter selling price';
                }
                return null;
              },
            ),
            16.vs,
            AppTextFormFields.intOnly(
              hint: 'Purchase Price',
              label: 'Purchase Price',
              controller: purchasePriceController,
              validator: (value) {
                if (!Validators().isValidateField(value)) {
                  return 'Please enter selling price';
                }
                return null;
              },
            ),
            140.vs,
            AppButton(
              isLoading: provider.isLoading,
              labelText: 'Save',
              onTap: () async {
                provider.changeLoading(true);
                if (_formKey.currentState?.validate() ?? false) {
                  double sell = double.parse(sellPriceController.text);
                  double buy = double.parse(purchasePriceController.text);
                  await provider.edit(widget.detail, widget.batch, sell, buy,
                      supplierController.text);
                  ToggleProvider().changeScreen(2);
                  provider.changeLoading(false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DashBoardScreen()),
                    (Route<dynamic> route) =>
                        false, // This removes all the previous routes
                  );
                }
              },
              labelStyle: TextStyles.bold(fontSize: 16, color: Colors.white),
            ),
          ],
        ).allp(16),
      ),
    );
  }
}
