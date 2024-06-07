import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/screens/add_channel_screen.dart';

import '../common/theme/text_styles.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        title: Text(
          'Channel',
          style: TextStyles.regular_black(fontSize: 16),
        ),
        actions: [
          GestureDetector(
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ).allp(5),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddChannelScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ).allp(20),
      ),
    );
  }
}
