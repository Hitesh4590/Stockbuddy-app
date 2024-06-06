import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import '../common/theme/color_constants.dart';
import '../common/util/validators.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController comapny_nameController = TextEditingController();
  TextEditingController comapny_addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorConstants.darkGrey,
      body: Stack(
        children: [
          buildBackgroundView(),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildImageView(),
                Text(
                  'Add Comapny',
                  style: TextStyles.bold(fontSize: 24, color: Colors.white),
                ),
                45.vs,
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConstants.darkGrey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: buildForm()),
                ),
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

  Widget buildForm() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _getImage();
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: ColorConstants.lightGrey,
                            backgroundImage: imageXFile == null
                                ? null
                                : FileImage(
                                    File(imageXFile!.path),
                                  ),
                            child: imageXFile == null
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
                    Text(
                      'Company Image',
                      style: TextStyles.regular(
                          fontSize: 10, color: ColorConstants.lightGrey),
                    )
                  ],
                ),
              ),
              20.vs,
              AppTextFormFields(
                hint: 'Company Name',
                controller: comapny_nameController,
                validator: (value) {
                  Validators().isValidateField(value);
                },
              ),
              20.vs,
              AppTextFormFields(
                hint: 'Email ID ',
                controller: emailController,
                validator: (value) {
                  Validators().validateEmail(value);
                },
              ),
              20.vs,
              AppTextFormFields(
                hint: 'Comapny Address',
                controller: comapny_addressController,
                validator: (value) {
                  Validators().isValidateField(value);
                },
              ),
              20.vs,
              AppButton(
                labelText: 'Save',
                onTap: () {},
                color: ColorConstants.darkGrey,
              ),
              20.vs,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Remind me later',
                        style: TextStyles.bold(color: ColorConstants.darkGrey),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}

Widget buildImageView() {
  return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.all(70),
      child: SvgPicture.asset(
        ImageConstants.appLogo,
        height: 74,
        width: 228,
      ));
}
