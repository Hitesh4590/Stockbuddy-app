import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/util/validators.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';
import 'package:stockbuddy_flutter_app/screens/dash_board_screen.dart';
import 'package:stockbuddy_flutter_app/screens/database_service.dart';
import 'package:stockbuddy_flutter_app/screens/forgot_password_screen.dart';
import 'package:stockbuddy_flutter_app/screens/sign_up_screen.dart';

import '../common/theme/color_constants.dart';
import '../common/theme/image_constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool remember_me = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              ))
            ],
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildImageView(),
                Text(
                  'Welcome Back',
                  style: TextStyles.bold(fontSize: 24, color: Colors.white),
                ),
                Text(
                  'Enter your credentials to sign in',
                  style: TextStyles.medium(color: Colors.white, fontSize: 10),
                ),
                45.vs,
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: ColorConstants.darkGrey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppTextFormFields(
                              hint: 'Email ID & Phone number',
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email address or phone no';
                                } else if (RegExp(
                                            r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                        .hasMatch(value) ||
                                    Validators().isValidateMobileNo(value)) {
                                  return null;
                                }
                                return 'Please enter a valid email address or phone no'; // Return null if the input is valid
                              },
                            ),
                            20.vs,
                            AppTextFormFields(
                              hint: 'Password',
                              controller: passwordController,
                              obscureText: toggle.signinObscure,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  toggle.toggleSigninObscure();
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
                                  return 'Please write 8 min character including one lower,upper and special character';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  value: toggle.rememberMe,
                                  onChanged: (value) {
                                    toggle.toggleRememberMe();
                                  },
                                ),
                                const Text('Remember me'),
                                20.hs,
                                Expanded(
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    ForgotPasswordScreen()));
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyles.bold(),
                                      )),
                                )
                              ],
                            ),
                            20.vs,
                            AppButton(
                              labelText: 'Sign in',
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (await DatabaseService().login(
                                      emailController.text.trim(),
                                      passwordController.text.trim())) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => DashBoardScreen()));
                                  }
                                }
                              },
                              color: ColorConstants.darkGrey,
                            ),
                            20.vs,
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('-----------Or Login with----------')
                              ],
                            ),
                            20.vs,
                            GestureDetector(
                                child: Container(
                                    width: double.infinity,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorConstants.darkGrey,
                                          width: 1),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstants.google,
                                          fit: BoxFit.contain,
                                        ),
                                        10.hs,
                                        Text(
                                          'Continue with google',
                                          style: TextStyles.bold(fontSize: 14),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => SignUpScreen()));
                                }),
                            20.vs,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyles.regular(),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => SignUpScreen()));
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyles.bold(
                                          color: ColorConstants.darkGrey),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
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

  Widget buildImageView() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(70),
      child: SvgPicture.asset(
        ImageConstants.appLogo,
        height: 74,
        width: 228,
      ),
    );
  }
}