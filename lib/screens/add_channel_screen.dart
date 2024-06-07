import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';

class AddChannelScreen extends StatefulWidget {
  const AddChannelScreen({super.key});

  @override
  State<AddChannelScreen> createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  final channelController = TextEditingController();
  final notesController = TextEditingController();
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text(
          'New Channel',
          style: TextStyles.regular_black(fontSize: 16),
        ),
      ),
      body: Form(
        child: Column(
          children: [
            40.vs,
            Center(
              child: InkWell(
                onTap: () {
                  _getImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: ColorConstants.lightGrey,
                      backgroundImage: imageXFile == null
                          ? null
                          : FileImage(File(imageXFile!.path)),
                      child: imageXFile == null
                          ? SvgPicture.asset(ImageConstants.gallery)
                          : null,
                    ),
                    Positioned(
                      left: 70,
                      top: 70,
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.04,
                          backgroundColor: Color(0xffEEEEEE),
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.black,
                          )),
                    )
                  ],
                ),
              ),
            ),
            20.vs,
            AppTextFormFields()
          ],
        ),
      ),
    );
  }
}
