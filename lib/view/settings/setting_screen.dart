import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/user/get_user_info_model.dart';
import 'package:cricketly/view/auth/login_screen.dart';
import 'package:cricketly/view/settings/edit_profile_screen.dart';
import 'package:cricketly/view/settings/my_team/myteam_screen.dart';
import 'package:cricketly/view/settings/player_profile_screen.dart';
import 'package:cricketly/view/settings/privacy_policy_screen.dart';
import 'package:cricketly/view/settings/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Map<String, dynamic> userInfo = {};
  GetUserInfoModel getUserInfoModel = GetUserInfoModel();

  @override
  void initState() {
    userInfo = json.decode(preferences.getString(Keys.userData) ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              "Settings",
              style: TextStyle(
                color: ConstColors.black,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
                fontSize: size.height * 0.04,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlayerProfileScreen(),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: userInfo['result']['profile_image'] ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          width: size.height * 0.15,
                          height: size.height * 0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          alignment: Alignment.center,
                          width: size.height * 0.15,
                          height: size.height * 0.15,
                          decoration: const BoxDecoration(
                            color: ConstColors.appGreen8FColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            userInfo['result']['username'][0],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.05,
                              color: ConstColors.white,
                            ),
                          ),
                        ),
                      )

                      // CachedNetworkImageView(
                      //   imageUrl: userData?.profileImage ?? '',
                      //   username: userData?.username ?? '',
                      //   imageSize: size.height * 0.15,
                      // ),
                      ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    userInfo['result']['username'],
                    style: TextStyle(
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.w600,
                      fontSize: size.height * 0.03,
                    ),
                  ),
                  Text(
                    userInfo['result']['email'],
                    style: TextStyle(
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.w500,
                      fontSize: size.height * 0.02,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const Divider(
                    color: ConstColors.grayColor95,
                  ),
                  _buildListTile(
                    leadingIcon: ConstImages.profileIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            imageUrl: userInfo['result']['profile_image'] ?? '',
                            address: userInfo['result']['address'] ?? "",
                            username: userInfo['result']['username'] ?? "",
                            email: userInfo['result']['email'] ?? "",
                            playerType: userInfo['result']['player_type'] ?? "",
                            batsmanType:
                                userInfo['result']['batsman_type'] ?? "",
                            bowlerType: userInfo['result']['bowler_type'] ?? "",
                            country: userInfo['result']['country'] ?? "",
                            mobileNo: userInfo['result']['mobile_no'] ?? "",
                            id: int.tryParse(
                                    preferences.get(Keys.userID).toString()) ??
                                0,
                            jerseyNo: userInfo['result']['jersey_no'] ?? "",
                          ),
                        ),
                      );
                    },
                    title: 'Edit Profile',
                  ),
                  _buildListTile(
                    leadingIcon: ConstImages.termsIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyTeamScreen(),
                        ),
                      );
                    },
                    title: 'My Team',
                  ),
                  _buildListTile(
                    leadingIcon: ConstImages.notificationIcon,
                    onTap: () {},
                    title: 'Notification',
                  ),
                  _buildListTile(
                    leadingIcon: ConstImages.termsIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsAndConditions(),
                        ),
                      );
                    },
                    title: 'Terms of use',
                  ),
                  _buildListTile(
                    leadingIcon: ConstImages.privacyIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                    title: 'Privacy Policy',
                  ),
                  _buildListTile(
                    leadingIcon: ConstImages.aboutUsIcon,
                    onTap: () {},
                    title: 'Help Center',
                  ),
                  ListTile(
                    onTap: () {
                      preferences.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: ConstColors.red,
                      ),
                    ),
                    // leading: SvgPicture.asset(
                    //   ConstImages.logoutIcon,
                    //   color: ConstColors.red,
                    // ),
                    trailing: SvgPicture.asset(
                      ConstImages.forwordIcon,
                      color: ConstColors.appGreen8FColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      {required String title,
      required void Function() onTap,
      required String leadingIcon}) {
    return ListTile(
      dense: true,
      // contentPadding: const EdgeInsets.only(top: 0),
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(
          letterSpacing: 0.7,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      // leading: SvgPicture.asset(
      //   leadingIcon,
      //   color: ConstColors.black.withOpacity(0.2),
      // ),
      trailing: SvgPicture.asset(
        ConstImages.forwordIcon,
        color: ConstColors.appGreen8FColor,
      ),
    );
  }
}
