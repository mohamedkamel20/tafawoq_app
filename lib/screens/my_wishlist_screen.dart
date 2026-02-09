import 'dart:async';
import 'package:tafawoq_app/providers/courses.dart';
import 'package:tafawoq_app/widgets/wishlist_grid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../l10n/app_localizations.dart';

class MyWishlistScreen extends StatefulWidget {
  const MyWishlistScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyWishlistScreenState createState() => _MyWishlistScreenState();
}

class _MyWishlistScreenState extends State<MyWishlistScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)?.myWishlist ?? 'My Wishlist',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future:
                Provider.of<Courses>(context, listen: false).fetchMyWishlist(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                      color: kPrimaryColor.withOpacity(0.7)),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return _connectionStatus == ConnectivityResult.none
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .15),
                              Image.asset(
                                "assets/images/no_connection.png",
                                height:
                                    MediaQuery.of(context).size.height * .35,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                    AppLocalizations.of(context)?.noInternet ??
                                        'There is no Internet connection'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(AppLocalizations.of(context)
                                        ?.checkInternet ??
                                    'Please check your Internet connection'),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          // child: Text('Error Occurred'),
                          child: Text(dataSnapshot.error.toString()),
                        );
                } else {
                  return Consumer<Courses>(
                    builder: (context, courseData, child) =>
                        AlignedGridView.count(
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 1,
                      itemCount: courseData.items.length,
                      itemBuilder: (ctx, index) {
                        return WishlistGrid(
                          course: courseData.items[index],
                        );
                        // return Text(myCourseData.items[index].title);
                      },
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
