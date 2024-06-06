import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/theme/app_theme.dart';
import 'package:stockbuddy_flutter_app/providers/add_inventory_provider.dart';
import 'package:stockbuddy_flutter_app/providers/home_screen_provider.dart';
import 'package:stockbuddy_flutter_app/providers/inventory_details_provider.dart';
import 'package:stockbuddy_flutter_app/providers/inventory_list_provider.dart';
import 'package:stockbuddy_flutter_app/providers/orders_screen_provider.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';
import 'package:stockbuddy_flutter_app/screens/inventory_list_screen.dart';
import 'package:stockbuddy_flutter_app/screens/sign_in_screen.dart';
import 'package:stockbuddy_flutter_app/services/auth_checker.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ToggleProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => HomeScreenProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => AddInventoryProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => InventoryListProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => InventoryDetailsProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => OrdersScreenProvider(),
      ),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return I18n(
      child: MaterialApp(
        title: 'stockbuddy',
        theme: AppTheme().getAppTheme(context),
        home: AuthChecker(),
      ),
    );
  }
}
