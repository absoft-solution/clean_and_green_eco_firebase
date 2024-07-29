// import 'package:clean_and_green/constant/color.dart';
// import 'package:clean_and_green/ui/camera/camera.dart';
// import 'package:flutter/material.dart';
// import '../home_screen/HomeScreen.dart';
// import '../profile_screen/profile_screen.dart';
//
// class NavigationScreen extends StatefulWidget {
//   const NavigationScreen({
//     Key? key,
//   }) : super(key: key);
//
//   // final String title;
//
//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }
//
// class _NavigationScreenState extends State<NavigationScreen> {
//   int _selectedIndex = 0;
//   Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
//     0: GlobalKey<NavigatorState>(),
//     1: GlobalKey<NavigatorState>(),
//     2: GlobalKey<NavigatorState>(),
//   };
//   final List<Widget> _widgetOptions = <Widget>[
//     const HomeScreen(),
//           CameraPage(),
//     const ProfileScreen()
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: greencolor,
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: ImageIcon(AssetImage("assets/images/camera.png")),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: ImageIcon(AssetImage("assets/images/camera.png")),
//             label: 'Business',
//           ),
//           BottomNavigationBarItem(
//             icon: ImageIcon(AssetImage("assets/images/camera.png")),
//             label: 'School',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//       body: buildNavigator(),
//     );
//   }
//
//   buildNavigator() {
//     return Navigator(
//       key: navigatorKeys[_selectedIndex],
//       onGenerateRoute: (RouteSettings settings) {
//         return MaterialPageRoute(
//             builder: (_) => _widgetOptions.elementAt(_selectedIndex));
//       },
//     );
//   }
// }
import 'dart:developer';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:camera/camera.dart';
import 'package:clean_and_green/ui/home_screen/HomeScreen.dart';
import 'package:clean_and_green/ui/profile_screen/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/color.dart';

import '../../core/auth/signInWithGoogle.dart';
import '../create_post/createPost.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;

  List<Widget> pages = [
    HomeScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];
  final SignInWithGoogle signinwithgoogle = SignInWithGoogle();

  @override
  void initState() {
    signinwithgoogle.signInWithGoogle();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          pageIndex == 0;
        });
        log(("testing ${pageIndex}"));
        return await true;
      },
      child: Scaffold(
        body: getBody(),
        bottomNavigationBar: getFooter(),
      ),
    );
  }

  Widget getBody() {
    // return pages.elementAt(pageIndex);
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<TabItem> items = [
      TabItem(
        icon: Icons.home_filled,
        title: 'Home',
      ),
      TabItem(
        icon: Icons.camera_alt,
        title: 'Camera',
      ),
      const TabItem(
        icon: Icons.manage_accounts,
        title: 'Profile',
      ),
    ];

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.120,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 2, color: Colors.black.withOpacity(0.06)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: BottomBarInspiredOutside(
          items: items,
          backgroundColor: Colors.green,
          color: Colors.white.withOpacity(0.5),
          colorSelected: Colors.white,
          indexSelected: pageIndex,
          itemStyle: ItemStyle.hexagon,
          isAnimated: true,
          animated: true,
          onTap: (index) {
            selectedTab(index, context);
          },
        ),
      ),
    );
  }

  selectedTab(index, BuildContext context) {
    setState(() {
      pageIndex = index;
      if (pageIndex == 1) {
        var imagepath = selectImageFromCamera(context);
        log("testing ${imagepath}");
      } else {
        pageIndex = index;
      }
    });
  }
}

selectImageFromCamera(BuildContext context) async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 10);

  if (file != null) {
    log('Image Picked');
    Fluttertoast.showToast(msg: 'Image Picked');
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePost(
                  image: file.path,
                )));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RootApp()));
    return '';
  }
}
