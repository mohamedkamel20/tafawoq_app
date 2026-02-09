// ignore_for_file: use_build_context_synchronously

import 'package:academy_app/constants.dart';
import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/providers/auth.dart';
import 'package:academy_app/screens/forgot_password_screen.dart';
import 'package:academy_app/screens/signup_screen.dart';
import 'package:academy_app/widgets/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/form_helpers.dart';

import '../models/user.dart';
import 'device_verifcation.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool hidePassword = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late User userDetails;

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  Future<void> _submit() async {
    if (!globalFormKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    await Provider.of<Auth>(context, listen: false)
        .login(
      _authData['email'].toString(),
      _authData['password'].toString(),
    )
        .then((_) {
      setState(() {
        _isLoading = false;
        userDetails = Provider.of<Auth>(context, listen: false).user;
      });
    });

    if (userDetails.validity == 1) {
      if (userDetails.deviceVerification == 'needed-verification') {
        Navigator.of(context)
            .pushNamed(DeviceVerificationScreen.routeName, arguments: {
          'email': userDetails.email,
          'token': userDetails.token, // Replace with the actual token value
        });
        CommonFunctions.showSuccessToast(
          userDetails.deviceVerification!.capitalize(),
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
        CommonFunctions.showSuccessToast(
            '${AppLocalizations.of(context)!.welcomeMessage}, ${userDetails.firstName} ${userDetails.lastName}');
      }
    } else {
      CommonFunctions.showErrorDialog(
          userDetails.deviceVerification!.capitalize(), context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        key: scaffoldKey,
        elevation: 0,
        iconTheme: const IconThemeData(color: kSelectItemColor),
        backgroundColor: kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Form(
                key: globalFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: kBackgroundColor,
                          child: Image.asset(
                            'assets/images/do_login.png',
                            height: 70,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.logIn,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 17.0, bottom: 5.0),
                            child: Text(
                              AppLocalizations.of(context)!.email,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 14),
                            decoration: FormHelpers.getInputDecorationColored(
                              context: context,
                              hintText: AppLocalizations.of(context)!.email,
                              fillColor: kBackgroundColor,
                              borderColor: Colors.white,
                              focusedBorderColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: kTextLowBlackColor,
                              ),
                            ),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (input) =>
                                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(input!)
                                    ? AppLocalizations.of(context)!.emailValid
                                    : null,
                            onSaved: (value) {
                              _authData['email'] = value.toString();
                              _emailController.text = value as String;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 17.0, bottom: 5.0),
                            child: Text(
                              AppLocalizations.of(context)!.password,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 15.0, bottom: 4.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            onSaved: (input) {
                              _authData['password'] = input.toString();
                              _passwordController.text = input as String;
                            },
                            validator: (input) => input!.length < 3
                                ? AppLocalizations.of(context)!.passwordShort
                                : null,
                            obscureText: hidePassword,
                            decoration: FormHelpers.getInputDecorationColored(
                              context: context,
                              hintText: AppLocalizations.of(context)!.password,
                              fillColor: kBackgroundColor,
                              borderColor: Colors.white,
                              focusedBorderColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.lock_outlined,
                                color: kTextLowBlackColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: kTextLowBlackColor,
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ForgotPassword.routeName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: const TextStyle(color: kSecondaryColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: MaterialButton(
                                    elevation: 0,
                                    color: kPrimaryColor,
                                    onPressed: _submit,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(10),
                                      // side: const BorderSide(color: kPrimaryColor),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.logIn,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.doNotHaveAccount,
                    style: const TextStyle(
                      color: kTextLowBlackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    },
                    child: Text(
                      ' ${AppLocalizations.of(context)!.signUp}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
