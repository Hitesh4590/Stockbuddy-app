import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import '../theme/color_constants.dart';
import '../theme/text_styles.dart';

class ChannelTile extends StatelessWidget {
  final String name;
  final String image;
  final String notes;
  final bool editable;
  final VoidCallback? editOnTap;
  final VoidCallback? deleteOnTap;

  const ChannelTile({
    super.key,
    required this.name,
    required this.image,
    required this.notes,
    required this.editable,
    this.editOnTap,
    this.deleteOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: (editable) ? 0.28 : 0.00001,
        motion: const ScrollMotion(),
        children: [
          if (editable)
            SizedBox(
              child: Builder(
                builder: (context) {
                  return Row(
                    children: [
                      InkWell(
                        onTap: editOnTap,
                        splashColor: ColorConstants.darkGrey,
                        child: Container(
                          padding: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                              color: ColorConstants.darkGrey),
                          child: Center(
                              child: SvgPicture.asset(
                            ImageConstants.edit2,
                            colorFilter: const ColorFilter.mode(
                                ColorConstants.orange, BlendMode.srcIn),
                          ).hp(18).vp(20)),
                        ),
                      ),
                      InkWell(
                        onTap: deleteOnTap,
                        splashColor: ColorConstants.darkGrey,
                        child: Container(
                          padding: EdgeInsets.zero,
                          decoration:
                              const BoxDecoration(color: ColorConstants.orange),
                          child: Center(
                              child: SvgPicture.asset(
                            ImageConstants.trash2,
                            colorFilter: const ColorFilter.mode(
                                ColorConstants.darkGrey, BlendMode.srcIn),
                            fit: BoxFit.scaleDown,
                          ).hp(18).vp(24)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          border: Border.all(color: ColorConstants.offWhite, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                  color: ColorConstants.offWhite, shape: BoxShape.circle),
              child: Image.network(image).allp(7.5),
            ),
            10.hs,
            Text(
              name,
              style: TextStyles.regularBlack(fontSize: 14),
            )
          ],
        ).allp(14),
      ),
    );
  }
}
