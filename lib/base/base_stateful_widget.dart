import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stockbuddy_flutter_app/common/theme/app_colors.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';

import 'base_bloc.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  /// This will hold Rx subscriptions and clear
  /// them in dispose to avoid memory leaks.
  final subscriptions = CompositeSubscription();

  /// Enforce extender to return base bloc so we can clear on dispose.
  /// This will prevent mistakes of forgetting calling dispose of BLoC.
  BaseBloc? getBaseBloc();

  @override
  void dispose() {
    super.dispose();
    subscriptions.clear();

    /// Extender might not have a BLoC implementation yet
    /// and will return null in that case.
    getBaseBloc()?.dispose();
  }

  void hideKeyboard() {
    /// Add hide keyboard event
    getBaseBloc()?.hideKeyboardSubject.add(true);
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenWidth(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).width / dividedBy;
  }

  void showSnackBar(BuildContext context, String message,
      {bool isUndoAction = false,
      VoidCallback? onUndo,
      VoidCallback? onVisible}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyles.regular(
          fontSize: 14,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.black,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      action: isUndoAction
          ? SnackBarAction(
              label: 'UNDO',
              textColor: AppColors.black,
              backgroundColor: Colors.white,
              onPressed: onUndo ?? () {},
            )
          : null,
      onVisible: onVisible,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
