import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';
import 'package:stockbuddy_flutter_app/screens/add_company_screen.dart';
import 'package:stockbuddy_flutter_app/screens/sign_in_screen.dart';
import '../screens/dash_board_screen.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ToggleProvider>();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen();
        }
        /* return DashBoardScreen();*/
        return FutureBuilder<void>(
          future: provider.getUser(FirebaseAuth.instance.currentUser?.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasError) {
              return Center(child: Text('Error: ${userSnapshot.error}'));
            }

            if (provider.user1 != null) {
              if (provider.user1!.isCompany) {
                return DashBoardScreen();
              } else {
                return AddCompanyScreen();
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
