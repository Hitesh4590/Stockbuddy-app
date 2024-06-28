import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/model/company.dart';
import 'package:stockbuddy_flutter_app/providers/add_company_provider.dart';
import 'package:stockbuddy_flutter_app/screens/dash_board_screen.dart';
import 'package:stockbuddy_flutter_app/screens/database_service.dart';
import '../common/theme/color_constants.dart';
import '../common/util/validators.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AddCompanyProvider>();
    return Scaffold(
      // backgroundColor: ColorConstants.darkGrey,
      body: Stack(
        children: [
          buildBackgroundView(),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                101.vs,
                buildImageView(),
                34.vs,
                Text(
                  'Add Company',
                  style: TextStyles.bold(fontSize: 24, color: Colors.white),
                ),
                1.vs,
                Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorConstants.darkGrey, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: buildForm(provider))
                    .allp(24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackgroundView() {
    return Column(
      children: [
        Container(
          height: 400,
          color: ColorConstants.darkGrey,
        ),
        Expanded(
            child: Container(
          color: Colors.white,
        ))
      ],
    );
  }

  Widget buildForm(AddCompanyProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  provider.getImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: ColorConstants.lightGrey,
                      backgroundImage: provider.imageXFile == null
                          ? null
                          : FileImage(
                              File(provider.imageXFile!.path),
                            ),
                      child: provider.imageXFile == null
                          ? SvgPicture.asset(ImageConstants.gallery)
                          : null,
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.18,
                      top: MediaQuery.of(context).size.width * 0.18,
                      child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xffEEEEEE),
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.black,
                          )),
                    )
                  ],
                ),
              ),
              7.vs,
              Text(
                'Company Image',
                style: TextStyles.small(),
              )
            ],
          ),
          24.vs,
          AppTextFormFields(
            hint: 'Company Name',
            controller: nameController,
            validator: (value) {
              if (!Validators().isValidateField(value)) {
                return 'please enter a valid name';
              }
              return null;
            },
          ),
          16.vs,
          AppTextFormFields(
            hint: 'Email ID ',
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email address';
              } else if (RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                  .hasMatch(value)) {
                return null;
              }
              return 'Please enter a valid email address'; // Return null if the input is valid
            },
          ),
          16.vs,
          AppTextFormFields(
            hint: 'Company Address',
            controller: addressController,
          ),
          24.vs,
          AppButton(
            isLoading: provider.isLoading,
            labelStyle: TextStyles.medium(color: Colors.white),
            labelText: 'Save',
            onTap: () async {
              String photo = '';
              if (provider.imageXFile != null) {
                photo = await provider.uploadImages(provider.imageXFile);
              }

              if (_formKey.currentState!.validate()) {
                provider.changeLoading(true);
                final Company1 = Company(
                  email: emailController.text.trim(),
                  name: nameController.text.trim(),
                  address: addressController.text.trim(),
                  photo: photo,
                );
                await provider.uploadCompanyDetails(Company1);
                provider.changeLoading(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Company details added successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashBoardScreen()));
              }
            },
            color: ColorConstants.darkGrey,
          ),
          24.vs,
        ],
      ),
    ).allp(24);
  }
}

Widget buildImageView() {
  return Container(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        ImageConstants.appLogo,
        height: 74,
        width: 228,
      )).hp(73);
}
