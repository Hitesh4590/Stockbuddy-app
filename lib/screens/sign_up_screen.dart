import 'package:country_code_text_field/country_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/screens/database_service.dart';
import 'package:stockbuddy_flutter_app/screens/home_screen.dart';
import '../common/theme/color_constants.dart';
import '../common/util/validators.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';

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
                buildImageView(),
                Text(
                  'Sign Up',
                  style: TextStyles.bold(fontSize: 24, color: Colors.white),
                ),
                Text(
                  'Create your account',
                  style: TextStyles.medium(color: Colors.white),
                ),
                45.vs,
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: ColorConstants.darkGrey, width: 1),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
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
                                ),
                                10.hs,
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
                            20.vs,
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
                            20.vs,
                            CountryCodeTextField(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
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
                            20.vs,
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
                                } else if (!Validators()
                                    .isValidPassword(value)) {
                                  return 'Please write 8 minimum character including one lowercase,uppercase and special character';
                                }
                                return null;
                              },
                            ),
                            20.vs,
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
                            20.vs,
                            AppButton(
                              borderRadius: BorderRadius.circular(50),
                              labelText: 'Sign up',
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (await DatabaseService().signup(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      firstnameController.text.trim(),
                                      lastnameController.text.trim(),
                                      phoneController.text.trim())) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => HomeScreen()));
                                  }
                                  ;
                                }
                              },
                              borderColor: Colors.grey,
                            ),
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
                      ).allp(10),
                    ),
                  ),
                ),
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
    padding: EdgeInsets.all(70),
    child: SvgPicture.asset(
      ImageConstants.appLogo,
      height: 74,
      width: 228,
    ),
  );
}
