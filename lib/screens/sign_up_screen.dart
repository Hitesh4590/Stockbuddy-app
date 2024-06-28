import 'package:country_code_text_field/country_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';
import 'package:stockbuddy_flutter_app/screens/add_company_screen.dart';
import 'package:stockbuddy_flutter_app/screens/dash_board_screen.dart';
import 'package:stockbuddy_flutter_app/screens/database_service.dart';
import '../common/theme/color_constants.dart';
import '../common/util/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var toggle = context.watch<ToggleProvider>();
    return Scaffold(
      // backgroundColor: ColorConstants.darkGrey,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 400,
                color: ColorConstants.darkGrey,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                101.vs,
                buildImageView(),
                34.vs,
                Text(
                  'Sign Up',
                  style: TextStyles.bold(fontSize: 24, color: Colors.white),
                ),
                5.vs,
                Text(
                  'Create your account',
                  style: TextStyles.small(color: Colors.white),
                ),
                1.vs,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: ColorConstants.darkGrey, width: 1),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                        AppTextFormFields(
                          showError: true,
                          hint: 'Email ID ',
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            } else if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),
                        16.vs,
                        CountryCodeTextField(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          controller: phoneController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
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
                            if (!Validators()
                                .isValidateMobileNo(value.toString())) {
                              return 'Please enter valid phone number';
                            }
                            return null;
                          },
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                        16.vs,
                        AppTextFormFields(
                          hint: 'Password',
                          controller: passwordController,
                          obscureText: toggle.signupPasswordObscure,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              toggle.toggleSignupPasswordObscure();
                            },
                            child: SvgPicture.asset(
                              ImageConstants.passwordToggle,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          validator: (value) {
                            if (passwordController.text.isEmpty) {
                              return 'Please enter password';
                            } else if (!Validators().isValidPassword(value)) {
                              return 'Please write 8 minimum character including one lowercase,uppercase and special character';
                            }
                            return null;
                          },
                        ),
                        16.vs,
                        AppTextFormFields(
                          showError: true,
                          hint: 'Confirm Password',
                          controller: confirmpasswordController,
                          obscureText: toggle.signupConfirmPasswordObscure,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              toggle.toggleSignupConfirmPasswordObscure();
                            },
                            child: SvgPicture.asset(
                              ImageConstants.passwordToggle,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          validator: (value) {
                            if (confirmpasswordController.text.isEmpty) {
                              return 'please enter confirm password';
                            } else if (confirmpasswordController.text !=
                                passwordController.text) {
                              return 'password do not match';
                            }
                            return null;
                          },
                        ),
                        24.vs,
                        AppButton(
                          labelText: 'Sign up',
                          isLoading: toggle.isLoadingSignUp,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              toggle.changeLoadingSignUp(true);
                              if (await DatabaseService().signup(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  firstnameController.text.trim(),
                                  lastnameController.text.trim(),
                                  phoneController.text.trim())) {
                                toggle.changeLoadingSignUp(false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('User registered successfully'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => AddCompanyScreen()));
                              }
                              ;
                            }
                          },
                          borderColor: Colors.grey,
                        ),
                        24.vs,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyles.regular(),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyles.bold(
                                    color: ColorConstants.darkGrey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).allp(24),
                ).allp(24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildImageView() {
  return Container(
    alignment: Alignment.bottomCenter,
    child: SvgPicture.asset(
      ImageConstants.appLogo,
      height: 74,
      width: 228,
    ),
  ).hp(73);
}
