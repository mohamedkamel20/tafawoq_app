import 'dart:convert';
import 'package:tafawoq_app/constants.dart';
import 'package:tafawoq_app/widgets/app_bar.dart';
import 'package:tafawoq_app/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'my_wishlist_screen.dart';
import 'my_courses_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/home';
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Widget> _pages = [
    const LoginScreen(),
    const HomeScreen(),
    const LoginScreen(),
    const LoginScreen(),
  ];

  var _isInit = true;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      bool isAuth;
      dynamic userData;
      dynamic response;
      dynamic token;
      // var token = await SharedPreferenceHelper().getAuthToken();
      // setState(() {});
      // if (token != null && token.isNotEmpty) {
      //   _isAuth = true;
      // } else {
      //   _isAuth = false;
      // }

      // _isAuth = Provider.of<Auth>(context, listen: false).isAuth;

      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userData = (prefs.getString('userData') ?? '');
      });
      if (userData != null && userData.isNotEmpty) {
        response = json.decode(userData);
        token = response['token'];
      }
      if (token != null && token.isNotEmpty) {
        isAuth = true;
      } else {
        isAuth = false;
      }

      if (isAuth) {
        _pages = [
          const MyCoursesScreen(),
          const HomeScreen(),
          const MyWishlistScreen(),
          const AccountScreen(),
        ];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showFilterModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return const FilterWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: const CustomAppBar(),
      body: _pages[_selectedPageIndex],
      // floatingActionButton: _selectedPageIndex != 3
      //     ? FloatingActionButton(
      //         onPressed: () => _showFilterModal(context),
      //         backgroundColor: kDarkButtonBg,
      //         child: const Icon(Icons.filter_list),
      //       )
      //     : null,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: const Icon(Icons.school_outlined),
            activeIcon: const Icon(Icons.school),
            label: AppLocalizations.of(context)?.myCourse ?? 'My Course',
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: AppLocalizations.of(context)?.wishlist ?? 'Wishlist',
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: const Icon(Icons.account_circle_outlined),
            activeIcon: const Icon(Icons.account_circle),
            label: AppLocalizations.of(context)?.account ?? 'Account',
          ),
        ],
        backgroundColor: Colors.white,
        unselectedItemColor: kSecondaryColor,
        selectedItemColor: kSelectItemColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
