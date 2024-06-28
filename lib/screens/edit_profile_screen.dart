import 'package:country_code_text_field/country_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/model/company.dart';
import 'package:stockbuddy_flutter_app/providers/profile_provider.dart';

import '../common/theme/color_constants.dart';
import '../common/theme/image_constants.dart';
import '../common/theme/text_styles.dart';
import '../common/util/validators.dart';
import '../common/widget/app_textfield.dart';
import '../model/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {super.key, required this.userDetails, required this.companyDetails});
  final UserModel userDetails;
  final Company companyDetails;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  @override
  void initState() {
    super.initState();
    firstnameController.text = widget.userDetails.firstName;
    lastnameController.text = widget.userDetails.lastName;
    phoneController.text = widget.userDetails.phone;
    companyNameController.text = widget.companyDetails.name ?? '';
    companyEmailController.text = widget.companyDetails.email ?? '';
    companyAddressController.text = widget.companyDetails.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ProfileProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
                iconSize: 16,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            32.hs,
            Text(
              'Edit Profile',
              style: TextStyles.regularBlack(fontSize: 16),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.vs,
              Text('Edit Personal Details',
                  style: TextStyles.bold(
                      fontSize: 14, color: ColorConstants.profileBlue)),
              20.vs,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppTextFormFields(
                      showError: true,
                      hint: 'First Name',
                      controller: firstnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  16.hs,
                  Expanded(
                    child: AppTextFormFields(
                      hint: 'Last Name',
                      showError: true,
                      controller: lastnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              16.vs,
              CountryCodeTextField(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                controller: phoneController,
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  errorStyle: TextStyles.regular(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  hintText: 'Phone Number',
                  hintStyle: TextStyles.regular(
                    fontSize: 14,
                    color: ColorConstants.lightGrey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorConstants.lightGrey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorConstants.lightGrey,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorConstants.lightGrey,
                      width: 1,
                    ),
                  ),
                ),
                showCountryFlag: false,
                initialCountryCode: 'IN',
                validator: (value) {
                  if (!Validators().isValidateMobileNo(value.toString())) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
              ),
              20.vs,
              Text(
                'Edit Company Details',
                style: TextStyles.bold(
                    fontSize: 14, color: ColorConstants.profileBlue),
              ),
              20.vs,
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: ColorConstants.lightGrey,
                      foregroundImage: provider.downloadUrl != ''
                          ? NetworkImage(provider.downloadUrl)
                          : null,
                      backgroundImage: NetworkImage(
                          (widget.companyDetails.photo!.isNotEmpty)
                              ? widget.companyDetails.photo!
                              : ImageConstants.backgroundImage),
                    ).onTap(() {
                      provider.getImage();
                    }),
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
              16.vs,
              AppTextFormFields(
                hint: 'Company Name',
                controller: companyNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter company name';
                  }
                  return null;
                },
              ),
              16.vs,
              AppTextFormFields(
                showError: true,
                hint: 'Email Id',
                controller: companyEmailController,
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
                showError: true,
                hint: 'Company Address',
                controller: companyAddressController,
              ),
              50.vs,
              AppButton(
                  isLoading: provider.isLoading,
                  labelStyle:
                      TextStyles.bold(color: Colors.white, fontSize: 16),
                  labelText: 'Save',
                  onTap: () async {
                    String pic = '';
                    if (provider.downloadUrl == '') {
                      pic = widget.companyDetails.photo ?? '';
                    } else {
                      pic = provider.downloadUrl;
                    }
                    if (_formKey.currentState?.validate() ?? false) {
                      provider.changeLoading(true);
                      final newCompany = Company(
                        email: companyEmailController.text,
                        name: companyNameController.text,
                        address: companyAddressController.text,
                        photo: pic,
                      );
                      await provider.updateDetails(
                          firstnameController.text,
                          lastnameController.text,
                          phoneController.text,
                          newCompany);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Updated Successfully',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      provider.changeLoading(false);
                      Navigator.pop(context);
                    }
                  })
            ],
          ),
        ).allp(16),
      ),
    );
  }
}
