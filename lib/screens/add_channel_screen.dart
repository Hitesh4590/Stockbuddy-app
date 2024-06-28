import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/util/validators.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/model/channel.dart';
import 'package:stockbuddy_flutter_app/providers/channel_provider.dart';
import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';

class AddChannelScreen extends StatefulWidget {
  final ChannelModel? channel;
  const AddChannelScreen({super.key, this.channel});

  @override
  State<AddChannelScreen> createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final channelController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.channel != null) {
      channelController.text = widget.channel!.channelName;
      notesController.text = widget.channel!.notes;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<ChannelProvider>(context, listen: false);
        provider.initChannelImage(widget.channel!.image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChannelProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            iconSize: 16,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text(
          widget.channel != null ? 'Edit Channel' : 'New Channel',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              40.vs,
              Center(
                child: InkWell(
                  onTap: () async {
                    if (widget.channel != null) {
                      await provider.channelImageChange();
                    } else {
                      await provider.getImage();
                    }
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: ColorConstants.lightGrey,
                        backgroundImage: _getBackgroundImage(provider),
                        child: _getBackgroundImage(provider) == null
                            ? SvgPicture.asset(ImageConstants.gallery)
                            : null,
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.18,
                        top: MediaQuery.of(context).size.width * 0.18,
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: ColorConstants.offWhite,
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                widget.channel != null ? '' : provider.imageError,
                style: TextStyles.medium(color: Colors.red),
              ),
              20.vs,
              AppTextFormFields(
                controller: channelController,
                hint: 'Channel Title',
                validator: (value) {
                  if (!Validators().isValidateField(value)) {
                    return 'please add title';
                  }
                  return null;
                },
              ),
              20.vs,
              AppTextFormFields.multiline(
                minLines: 6,
                hint: 'Notes',
                controller: notesController,
              ),
            ],
          ),
        ),
      ).allp(20),
      bottomNavigationBar: AppButton(
        isLoading: provider.isLoading,
        labelStyle: TextStyles.bold(color: Colors.white, fontSize: 16),
        borderRadius: BorderRadius.circular(20),
        labelText: (widget.channel != null) ? 'Update' : 'Save',
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            if (widget.channel != null) {
              provider.changeLoading(true);
              await provider.updateChannel(
                widget.channel!,
                provider.channelImage,
                channelController.text,
                notesController.text,
              );
              await provider.clearChannelImage();
              provider.changeLoading(false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('channel edited successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            } else {
              provider.changeLoading(true);
              final String photo = await provider.uploadImages(provider.image);
              final channel = ChannelModel(
                id: '',
                channelName: channelController.text,
                notes: notesController.text,
                image: photo,
              );
              await provider.addChannel(channel);
              provider.removeImage();
              provider.changeLoading(false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('channel added successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            }
          }
        },
      ).hp(16).bp(40),
    );
  }

  ImageProvider? _getBackgroundImage(ChannelProvider provider) {
    if (widget.channel != null && provider.channelImage.isNotEmpty) {
      return NetworkImage(provider.channelImage);
    } else if (provider.image != null) {
      return FileImage(File(provider.image!.path));
    } else {
      return null;
    }
  }
}
