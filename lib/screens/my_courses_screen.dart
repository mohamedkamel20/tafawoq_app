// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:tafawoq_app/providers/my_bundles.dart';
import 'package:tafawoq_app/providers/my_courses.dart';
import 'package:tafawoq_app/widgets/my_bundle_grid.dart';
import 'package:tafawoq_app/widgets/my_course_grid.dart';
import 'package:tafawoq_app/widgets/whatsapp_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  _MyCoursesScreenState createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _isLoading = true;
  dynamic bundleStatus = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

    addonStatus();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  _scrollListener() {
    // if (fixedScroll) {
    //   _scrollController.jumpTo(0);
    // }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> addonStatus() async {
    var url = '$BASE_URL/api/addon_status?unique_identifier=course_bundle';
    final response = await http.get(Uri.parse(url));
    setState(() {
      _isLoading = false;
      bundleStatus = json.decode(response.body)['status'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: kPrimaryColor.withOpacity(0.7)),
            )
          : bundleStatus == true
              ? NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: false,
                            indicatorColor: kPrimaryColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor),
                            unselectedLabelColor: Colors.black87,
                            dividerHeight: 0,
                            labelColor: Colors.white,
                            tabs: [
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.play_lesson,
                                      size: 15,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)?.myCourses ??
                                          'My Courses',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.all_inbox,
                                      size: 15,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)?.myBundles ??
                                          'My Bundles',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      courseView(),
                      bundleView(),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)?.myCourses ??
                                  'My Courses',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      courseView(),
                    ],
                  ),
                ),
    );
  }

  Widget courseView() {
    return FutureBuilder(
      future: Provider.of<MyCourses>(context, listen: false).fetchMyCourses(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .7,
            child: Center(
              child: CircularProgressIndicator(
                  color: kPrimaryColor.withOpacity(0.7)),
            ),
          );
        } else {
          if (dataSnapshot.error != null) {
            //error
            return _connectionStatus == ConnectivityResult.none
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .15),
                        Image.asset(
                          "assets/images/no_connection.png",
                          height: MediaQuery.of(context).size.height * .35,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                              AppLocalizations.of(context)?.noInternet ??
                                  'There is no Internet connection'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                              AppLocalizations.of(context)?.checkInternet ??
                                  'Please check your Internet connection'),
                        ),
                      ],
                    ),
                  )
                : Center(
                    // child: Text('Error Occured'),
                    child: Text(dataSnapshot.error.toString()),
                  );
          } else {
            return Consumer<MyCourses>(
              builder: (context, myCourseData, child) => myCourseData
                      .items.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .15),
                          Icon(
                            Icons.school_outlined,
                            size: 100,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)
                                    ?.notSubscribedToCourses ??
                                'You are not subscribed to courses',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              AppLocalizations.of(context)?.pleaseContactUs ??
                                  'Please call or send WhatsApp to',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '0105 0498178',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const WhatsAppButton(
                            phoneNumber: '01050498178',
                            message: 'Hello, I want to subscribe to courses',
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        AlignedGridView.count(
                          padding: const EdgeInsets.all(10.0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          itemCount: myCourseData.items.length,
                          itemBuilder: (ctx, index) {
                            return MyCourseGrid(
                              myCourse: myCourseData.items[index],
                            );
                          },
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                        ),
                        // Help section when courses exist
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.help_outline,
                                size: 40,
                                color: kPrimaryColor.withOpacity(0.7),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)?.needHelp ??
                                    'Need Help?',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)
                                        ?.contactUsForHelp ??
                                    'If you need help with your courses, call us or send a WhatsApp message',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  '0105 0498178',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                    letterSpacing: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const WhatsAppButton(
                                phoneNumber: '01050498178',
                                message: 'Hello, I need help with my courses',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          }
        }
      },
    );
  }

  Widget bundleView() {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: Provider.of<MyBundles>(context, listen: false).fetchMybundles(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: kPrimaryColor.withOpacity(0.7)),
            );
          } else {
            if (dataSnapshot.error != null) {
              //error
              return _connectionStatus == ConnectivityResult.none
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .15),
                          Image.asset(
                            "assets/images/no_connection.png",
                            height: MediaQuery.of(context).size.height * .35,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                                AppLocalizations.of(context)?.noInternet ??
                                    'There is no Internet connection'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                                AppLocalizations.of(context)?.checkInternet ??
                                    'Please check your Internet connection'),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      // child: Text('Error Occured'),
                      child: Text(dataSnapshot.error.toString()),
                    );
            } else {
              return Consumer<MyBundles>(
                builder: (context, myBundleData, child) => myBundleData
                        .bundleItems.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .15),
                            Icon(
                              Icons.all_inbox_outlined,
                              size: 100,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)
                                      ?.notSubscribedToCourses ??
                                  'You are not subscribed to courses',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                AppLocalizations.of(context)?.pleaseContactUs ??
                                    'Please call or send WhatsApp to',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                '0105 0498178',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const WhatsAppButton(
                              phoneNumber: '01050498178',
                              message: 'Hello, I want to subscribe to courses',
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          AlignedGridView.count(
                            padding: const EdgeInsets.all(10.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            itemCount: myBundleData.bundleItems.length,
                            itemBuilder: (ctx, index) {
                              return MyBundleGrid(
                                myBundle: myBundleData.bundleItems[index],
                              );
                            },
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                          ),
                          // Help section when bundles exist
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.help_outline,
                                  size: 40,
                                  color: kPrimaryColor.withOpacity(0.7),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppLocalizations.of(context)?.needHelp ??
                                      'Need Help?',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)
                                          ?.contactUsForHelp ??
                                      'If you need help with your courses, call us or send a WhatsApp message',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    '0105 0498178',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                      letterSpacing: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const WhatsAppButton(
                                  phoneNumber: '01050498178',
                                  message: 'Hello, I need help with my courses',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
