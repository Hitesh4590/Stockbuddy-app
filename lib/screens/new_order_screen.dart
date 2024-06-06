import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';

import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';
import '../common/util/validators.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController skuNoController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text(
          'New Order',
          style: TextStyles.regular_black(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
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
                    child: AppTextFormFields(
                      controller: skuNoController,
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
                          color: ColorConstants.darkGrey,
                          border: Border.all(width: 1),
                        ),
                        child:
                            SvgPicture.asset(ImageConstants.barcode).allp(10)),
                  ),
                ],
              ),
              40.vs,
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
              20.vs,
              AppTextFormFields.intOnly(
                  controller: phoneNoController,
                  hint: 'Mobile Number',
                  validator: (value) {
                    Validators().validatePhoneNumber(value);
                  }),
            ],
          ).allp(20),
        ),
      ),
    );
  }
}
