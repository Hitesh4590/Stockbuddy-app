import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/providers/add_inventory_provider.dart';

import '../theme/image_constants.dart';

class UploadImageWidget extends StatelessWidget {
  UploadImageWidget({super.key, required this.provider, required this.index});

  final AddInventoryProvider provider;
  final int index;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      provider.addImage(image, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _getImage();
      },
      child: Stack(
        children: [
          Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  color: const Color(0xffF1F1F1),
                  borderRadius: BorderRadius.circular(10)),
              child: provider.images[index] == null
                  ? SvgPicture.asset(
                      ImageConstants.uploadImage,
                      fit: BoxFit.contain,
                    ).allp(10)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                      child: Image.file(
                        File(provider.images[index]!.path),
                        fit: BoxFit.cover,
                      ),
                    )),
          if (provider.images[index] != null)
            Positioned(
              left: 52,
              child: InkWell(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.03,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(ImageConstants.cancelImage),
                ),
                onTap: () {
                  provider.removeImage(index);
                },
              ),
            )
        ],
      ),
    );
  }
}
