import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/common/widget/channel_tile.dart';
import 'package:stockbuddy_flutter_app/model/channel.dart';
import 'package:stockbuddy_flutter_app/providers/channel_provider.dart';
import 'package:stockbuddy_flutter_app/screens/add_channel_screen.dart';

import '../common/theme/text_styles.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen>
    with TickerProviderStateMixin {
  late final SlidableController slidableController;
  @override
  void initState() {
    slidableController = SlidableController(this);
    super.initState();
    final provider = Provider.of<ChannelProvider>(context, listen: false);
    provider.fetchChannel();
  }

  void _editChannel(BuildContext context, ChannelModel channel,
      ChannelProvider provider) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddChannelScreen(
          channel: channel,
        ),
      ),
    );
    provider.fetchChannel();
    slidableController.close();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChannelProvider>();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Channel',
                style: TextStyles.regularBlack(fontSize: 16),
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset(ImageConstants.addButton),
              ).onTap(() async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddChannelScreen()));
                provider.fetchChannel();
              })
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.vs,
              Text(
                'System Channel',
                style: TextStyles.regular(),
              ),
              13.vs,
              SizedBox(
                width: double.infinity,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: provider.sysChannel.length,
                    itemBuilder: (context, index) {
                      ChannelModel channel = provider.sysChannel[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ChannelTile(
                          image: channel.image,
                          name: channel.channelName,
                          notes: channel.notes,
                          editable: false,
                          editOnTap: () =>
                              _editChannel(context, channel, provider),
                        ),
                      );
                    }),
              ),
              32.vs,
              if (provider.userChannel.isNotEmpty)
                Text(
                  'Other',
                  style: TextStyles.regular(),
                ),
              5.vs,
              if (provider.userChannel.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: provider.userChannel.length,
                      itemBuilder: (context, index) {
                        ChannelModel channel = provider.userChannel[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ChannelTile(
                            controller: slidableController,
                            image: channel.image,
                            name: channel.channelName,
                            notes: channel.notes,
                            editable: true,
                            editOnTap: () =>
                                _editChannel(context, channel, provider),
                            deleteOnTap: () {
                              _deleteChannel(context, channel, provider);
                            },
                          ),
                        );
                      }),
                ),
            ],
          ).allp(16),
        ));
  }
}

void _deleteChannel(
    BuildContext context, ChannelModel channel, ChannelProvider provider) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            20.vs,
            Text(
              'Delete Channel',
              style: TextStyles.bold(fontSize: 14),
            ),
            16.vs,
            Text(
              'Are you sure you want to delete \nthis channel? ',
              style: TextStyles.regular(),
            ),
            38.vs,
            AppButton(
              isLoading: provider.isLoadingDelete,
              labelText: 'Delete',
              onTap: () async {
                await provider.changeLoadingDelete(true);
                await provider.deleteChannel(channel);
                await provider.changeLoadingDelete(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(' Channel deleted successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
              buttonWidth: 155,
            )
          ],
        ),
      );
    },
  );
}
