import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/screens/change_password_screen.dart';
import 'package:stockbuddy_flutter_app/screens/database_service.dart';
import 'package:stockbuddy_flutter_app/screens/sign_in_screen.dart';
import 'package:stockbuddy_flutter_app/screens/your_profile_screen.dart';
import '../common/theme/text_styles.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      backgroundColor: ColorConstants.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 306,
                  decoration: const BoxDecoration(
                      color: ColorConstants.offWhite,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${provider.userDetails?.firstName ?? ''}  ${provider.userDetails?.lastName}',
                        style: TextStyles.regularBlack(fontSize: 24),
                      ),
                      Text(
                        provider.userDetails?.email ?? '',
                        style: TextStyles.small(),
                      ),
                      18.vs,
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  color: ColorConstants.offWhite,
                ),
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      color: ColorConstants.white,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(40))),
                ),
              ],
            ),
            Positioned(
              top: 306,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 400,
                decoration: const BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Info',
                      style: TextStyles.regular(),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(ImageConstants.profileYourProfile)
                                .vp(10),
                            16.hs,
                            Text(
                              'Your Profile',
                              style: TextStyles.regularBlack(fontSize: 14),
                            ).vp(10),
                            const Spacer(),
                            SvgPicture.asset(ImageConstants.profileArrowRight)
                                .vp(10),
                          ],
                        ).onTap(() async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YourProfileScreen()));
                          provider.fetchDetails();
                        }),
                        Row(
                          children: [
                            SvgPicture.asset(
                                    ImageConstants.profilePrivacyPolicy)
                                .vp(10),
                            16.hs,
                            Text(
                              'Privacy Policy',
                              style: TextStyles.regularBlack(fontSize: 14),
                            ).vp(10),
                            const Spacer(),
                            SvgPicture.asset(ImageConstants.profileArrowRight)
                                .vp(10),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                                    ImageConstants.profileChangePassword)
                                .vp(10),
                            16.hs,
                            Text(
                              'Change Password',
                              style: TextStyles.regularBlack(fontSize: 14),
                            ).vp(10),
                            const Spacer(),
                            SvgPicture.asset(ImageConstants.profileArrowRight)
                                .vp(10),
                          ],
                        ).onTap(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangePasswordScreen()));
                        }),
                        Row(
                          children: [
                            SvgPicture.asset(ImageConstants.profileLogout)
                                .vp(10),
                            16.hs,
                            Text(
                              'Logout ',
                              style: TextStyles.regularBlack(fontSize: 14),
                            ).vp(10),
                          ],
                        ).onTap(() async {
                          await DatabaseService().logout();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                            (Route<dynamic> route) =>
                                false, // This removes all the previous routes
                          );
                        })
                      ],
                    ).hp(14).vp(25)
                  ],
                ).hp(16).vp(26),
              ),
            ),
            Positioned(
              top: 0,
              child: SvgPicture.asset(
                ImageConstants.profileTopBackground,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              top: 122,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                ImageConstants.profileLogo,
              ),
            )
          ],
        ),
      ),
    );
  }
}
