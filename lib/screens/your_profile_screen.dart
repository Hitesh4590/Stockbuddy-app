import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_button.dart';
import 'package:stockbuddy_flutter_app/model/company.dart';
import 'package:stockbuddy_flutter_app/model/user.dart';
import 'package:stockbuddy_flutter_app/providers/profile_provider.dart';
import 'package:stockbuddy_flutter_app/screens/edit_profile_screen.dart';
import 'package:stockbuddy_flutter_app/screens/sign_in_screen.dart';

import '../common/theme/text_styles.dart';

class YourProfileScreen extends StatefulWidget {
  const YourProfileScreen({super.key});

  @override
  State<YourProfileScreen> createState() => _YourProfileScreenState();
}

class _YourProfileScreenState extends State<YourProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ProfileProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
                iconSize: 16,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            32.hs,
            Text(
              'Your Profile',
              style: TextStyles.regularBlack(fontSize: 16),
            ),
            const Spacer(),
            SvgPicture.asset(ImageConstants.yourProfileEdit).onTap(() async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                            companyDetails: provider.companyDetails ??
                                Company(
                                    photo: '',
                                    address: '',
                                    id: '',
                                    email: '',
                                    name: ''),
                            userDetails: provider.userDetails ??
                                UserModel(
                                    isCompany: false,
                                    id: '',
                                    email: '',
                                    firstName: '',
                                    lastName: '',
                                    phone: '',
                                    userId: ''),
                          )));
              provider.fetchDetails();
            })
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.vs,
            Text(
              'Personal Details',
              style: TextStyles.bold(
                  fontSize: 14, color: ColorConstants.profileBlue),
            ),
            20.vs,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color(0xff000000).withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Name:',
                        style: TextStyles.medium(),
                      ),
                      const Spacer(),
                      Text(
                        '${provider.userDetails?.firstName}  ${provider.userDetails!.lastName}',
                        style: TextStyles.regularBlack(fontSize: 14),
                      ),
                    ],
                  ),
                  12.vs,
                  Container(
                    height: 1,
                    width: MediaQuery.sizeOf(context).width - 64,
                    decoration: BoxDecoration(
                      color: const Color(0xff000000).withOpacity(0.1),
                    ),
                  ),
                  12.vs,
                  Row(
                    children: [
                      Text(
                        'Email Id:',
                        style: TextStyles.medium(),
                      ),
                      const Spacer(),
                      Text(
                        provider.userDetails?.email ?? '',
                        style: TextStyles.regularBlack(fontSize: 14),
                      ),
                    ],
                  ),
                  12.vs,
                  Container(
                    height: 1,
                    width: MediaQuery.sizeOf(context).width - 64,
                    decoration: BoxDecoration(
                      color: const Color(0xff000000).withOpacity(0.1),
                    ),
                  ),
                  12.vs,
                  Row(
                    children: [
                      Text(
                        'Mobile No:',
                        style: TextStyles.medium(),
                      ),
                      const Spacer(),
                      Text(
                        provider.userDetails?.phone ?? '',
                        style: TextStyles.regularBlack(fontSize: 14),
                      ),
                    ],
                  ),
                  12.vs,
                ],
              ).allp(16),
            ),
            20.vs,
            Text(
              'Company Details',
              style: TextStyles.bold(
                  fontSize: 14, color: ColorConstants.profileBlue),
            ),
            20.vs,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color(0xff000000).withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: ColorConstants.lightGrey,
                        foregroundImage: NetworkImage(
                            (provider.companyDetails!.photo!.isNotEmpty)
                                ? provider.companyDetails!.photo!
                                : ImageConstants.backgroundImage),
                      ),
                    ],
                  ),
                  20.vs,
                  Row(
                    children: [
                      Text(
                        'Company Name:',
                        style: TextStyles.medium(),
                      ),
                      const Spacer(),
                      Text(
                        provider.companyDetails?.name ?? '',
                        style: TextStyles.regularBlack(fontSize: 14),
                      ),
                    ],
                  ),
                  12.vs,
                  Container(
                    height: 1,
                    width: MediaQuery.sizeOf(context).width - 64,
                    decoration: BoxDecoration(
                      color: const Color(0xff000000).withOpacity(0.1),
                    ),
                  ),
                  12.vs,
                  Row(
                    children: [
                      Text(
                        'Email Id:',
                        style: TextStyles.medium(),
                      ),
                      const Spacer(),
                      Text(
                        provider.companyDetails?.email ?? '',
                        style: TextStyles.regularBlack(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ).allp(16),
            ),
            20.vs,
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: const Color(0xff000000).withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address:', style: TextStyles.medium()).lp(16),
                  8.hs,
                  Expanded(
                    child: Text(provider.companyDetails?.address ?? '',
                        style: TextStyles.regularBlack(fontSize: 14)),
                  ),
                ],
              ).vp(16).lp(16).rp(8),
            ),
            140.vs,
            AppButton(
                labelStyle: TextStyles.bold(color: Colors.white, fontSize: 16),
                labelText: 'Delete Account',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            contentPadding: EdgeInsets.all(10),
                            elevation: 0,
                            backgroundColor: Colors.white,
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: SvgPicture.asset(
                                        ImageConstants.cross,
                                        height: 10,
                                        width: 10,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.black, BlendMode.srcIn),
                                      ).onTap(() {
                                        Navigator.pop(context);
                                      }),
                                    ),
                                  ),
                                  20.vs,
                                  Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Delete Account',
                                          style: TextStyles.bold(fontSize: 14),
                                        ),
                                        16.vs,
                                        Text(
                                          'Are you Sure you want to delete\n this account?',
                                          style: TextStyles.regular(),
                                        ),
                                        38.vs,
                                        AppButton(
                                            isLoading: provider.isLoadingDelete,
                                            labelStyle: TextStyles.bold(
                                                color: Colors.white,
                                                fontSize: 16),
                                            labelText: 'Delete',
                                            onTap: () async {
                                              provider
                                                  .changeLoadingDelete(true);
                                              await provider.deleteAccount();
                                              provider
                                                  .changeLoadingDelete(false);
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignInScreen()),
                                                (Route<dynamic> route) =>
                                                    false, // This removes all the previous routes
                                              );
                                            }),
                                        20.vs,
                                      ],
                                    ).allp(10),
                                  ),
                                ]));
                      });
                }),
          ],
        ).allp(16),
      ),
    );
  }
}
