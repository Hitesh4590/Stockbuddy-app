import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/screens/sign_in_screen.dart';

import '../common/theme/color_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  Widget build(BuildContext context) {
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
                  '\t\t\t\t\t Enter the email address you’d like \t \n your password reset information sent to ',
                  style: TextStyles.small(color: Colors.white),
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
                          labelText: 'Request Reset Link',
                          onTap: () {},
                          prefixIcon: Icon(Icons.add_reaction_rounded),
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
                                  "< Back To Login",
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
