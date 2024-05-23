import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';

import 'app_shimmer_view.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;

  const AppNetworkImage({super.key, required this.url, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      height: height,
      width: width,
      errorWidget: (_, __, ___) =>
          const Icon(Icons.image),
      progressIndicatorBuilder: (_, child, __) => const AppShimmerView(
        child: ColoredBox(color: ColorConstants.primaryLight,),
      ),
    );
  }
}
