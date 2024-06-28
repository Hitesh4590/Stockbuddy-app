import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';

import '../common/theme/color_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> forgotPassword() async {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
    }

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
                101.vs,
                buildImageView(),
                34.vs,
                Text(
                  'Forgot Password',
                  style: TextStyles.bold(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                5.vs,
                Text(
                  textAlign: TextAlign.center,
                  'Enter the email address you’d like  \n your password reset information sent to ',
                  style: TextStyles.small(
                    color: Colors.white,
                  ),
                ),
                1.vs,
                Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: ColorConstants.darkGrey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextFormFields(
                          hint: 'Email ID',
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
                        30.vs,
                        AppButton(
                          labelStyle: TextStyles.bold(
                              fontSize: 14, color: Colors.white),
                          labelText: 'Request Reset Link',
                          onTap: () async {
                            try {
                              await forgotPassword();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Reset Password Email Sent'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid Email'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          borderColor: Colors.grey,
                        ),
                        10.vs,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  '< Back To Login',
                                  style: TextStyles.bold(),
                                ))
                          ],
                        )
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
