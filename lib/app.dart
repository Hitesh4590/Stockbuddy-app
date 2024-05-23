import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:stockbuddy_flutter_app/auth/ui/login_page.dart';
import 'package:stockbuddy_flutter_app/common/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return I18n(
      child: MaterialApp(
        title: 'Boilerplate!',
        theme: AppTheme().getAppTheme(context),
        home: const LoginPage(),
      ),
    );
  }
}
