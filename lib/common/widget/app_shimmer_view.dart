import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';

class AppShimmerView extends StatelessWidget {
  const AppShimmerView({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorConstants.black,
      highlightColor: ColorConstants.primaryLight,
      child: child,
    );
  }
}
