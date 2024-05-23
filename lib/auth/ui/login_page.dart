import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/app/app_configurations.dart';
import 'package:stockbuddy_flutter_app/auth/bloc/login_bloc.dart';
import 'package:stockbuddy_flutter_app/base/base_bloc.dart';
import 'package:stockbuddy_flutter_app/base/base_stateful_widget.dart';
import 'package:stockbuddy_flutter_app/common/extensions.dart';
import 'package:stockbuddy_flutter_app/common/i18n/i18n_engine.dart';
import 'package:stockbuddy_flutter_app/common/theme/app_colors.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {

  final LoginBloc _bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 16,
        ),
        child: Center(
          child: Card(
            elevation: 0,
            color: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Flavour: ${AppConfigurations.instance.appEnvironment}',
                  ),
                  4.vs,
                  Text(
                    'apiBaseUrl: ${AppConfigurations.instance.apiBaseUrl}',
                  ),
                  4.vs,
                  Text(
                    'msg_sign_in'.i18n,
                  ),
                  30.vs,
                  AppTextFormFields(
                    label: 'email_address'.i18n,
                  ),
                  8.vs,
                  AppTextFormFields(
                    label: 'password'.i18n,
                  ),
                  50.vs,
                  AppButton(
                    labelText: 'sign_in'.i18n,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return _bloc;
  }
}
