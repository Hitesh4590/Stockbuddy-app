import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/providers/profile_provider.dart';

import '../common/theme/image_constants.dart';
import '../common/theme/text_styles.dart';
import '../common/util/validators.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
              'Change Password',
              style: TextStyles.regularBlack(fontSize: 16),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              20.vs,
              AppTextFormFields(
                hint: 'Current Password',
                controller: currentPasswordController,
                obscureText: provider.currentPassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    provider.toggleCurrentPassword();
                  },
                  child: SvgPicture.asset(
                    ImageConstants.passwordToggle,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                validator: (value) {
                  if (passwordController.text.isEmpty) {
                    return 'Please enter current password';
                  } else if (!Validators().isValidPassword(value)) {
                    return 'Please write 8 minimum character including one lowercase,uppercase and special character';
                  }
                  return null;
                },
              ),
              16.vs,
              AppTextFormFields(
                hint: 'New Password',
                controller: passwordController,
                obscureText: provider.password,
                suffixIcon: GestureDetector(
                  onTap: () {
                    provider.togglePassword();
                  },
                  child: SvgPicture.asset(
                    ImageConstants.passwordToggle,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                validator: (value) {
                  if (passwordController.text.isEmpty) {
                    return 'Please enter new password';
                  } else if (!Validators().isValidPassword(value)) {
                    return 'Please write 8 minimum character including one lowercase,uppercase and special character';
                  }
                  return null;
                },
              ),
              16.vs,
              AppTextFormFields(
                showError: true,
                hint: 'Confirm New Password',
                controller: confirmPasswordController,
                obscureText: provider.confirmPassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    provider.toggleConfirmPassword();
                  },
                  child: SvgPicture.asset(
                    ImageConstants.passwordToggle,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                validator: (value) {
                  if (confirmPasswordController.text.isEmpty) {
                    return 'please enter confirm new password';
                  } else if (confirmPasswordController.text !=
                      passwordController.text) {
                    return 'password do not match';
                  }
                  return null;
                },
              ),
              40.vs,
              AppButton(
                labelText: 'Change Password',
                onTap: () async {
                  try {
                    await provider
                        .reAuthenticateUser(currentPasswordController.text);
                    await provider.changePassword(
                        context, passwordController.text);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                labelStyle: TextStyles.bold(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ).allp(16),
      ),
    );
  }
}
