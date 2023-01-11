import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/controller/user/user_controller.dart';
import 'package:cricketly/view/chat/all_user_list_screen.dart';
import 'package:cricketly/view/home/home_screen.dart';
import 'package:cricketly/view/match/start_new_game_screen.dart';
import 'package:cricketly/view/settings/setting_screen.dart';

import 'package:cricketly/widgtes/custom_bottombar.dart';
import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  int selectedIndex;
  BottomBarScreen({required this.selectedIndex});
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with TickerProviderStateMixin {
  final List<Widget> _widgetList = [
    const HomeScreen(),
    const StartNewGameScreen(),
    const AllUserListScreen(),
    const SettingScreen(),
  ];

  UserController userController = UserController();
  @override
  void initState() {
    userController.getUserInfoSink(
        userId: preferences.getString(Keys.userID) ?? '');
    super.initState();
  }
  //   @override
//   void initState() {
//     firebaseMessaging.getToken().then((token) {
//       deviceToken = token!;
//     });
//     // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//     //   await NotificationService().showNotification();
//     // });

//     FirebaseMessaging.onMessage.listen(
//       (RemoteMessage message) async {
//         if (message.notification != null) {
//           await NotificationService().showNotification();
//           if (message.notification?.title == 'title') {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => BottomBarscreen(selectedTabIndex: 0),
//             ));
//           }
//         }
//       },
//     );

//     //background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       if (message.notification?.title == 'title') {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => BottomBarscreen(selectedTabIndex: 0),
//         ));
//       }
//     });
//     //kill
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message?.notification?.title == 'title') {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => BottomBarscreen(selectedTabIndex: 0),
//         ));
//       }
//     });
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomLineIndicatorBottomNavbar(
        selectedColor: ConstColors.appGreen8FColor,
        unSelectedColor: ConstColors.white,
        onTap: onTapped,
        currentIndex: widget.selectedIndex,
        customBottomBarItems: [
          CustomBottomBarItems(
            icon: ConstImages.homeIcon,
            label: '',
          ),
          CustomBottomBarItems(icon: ConstImages.matchIcon, label: ''),
          CustomBottomBarItems(icon: ConstImages.messageIcon, label: ''),
          CustomBottomBarItems(icon: ConstImages.settingIcon, label: ''),
        ],
      ),
      body: _widgetList[widget.selectedIndex],
    );
  }

  void onTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }
}
