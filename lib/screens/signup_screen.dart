// ignore_for_file: use_build_context_synchronously

import 'package:tafawoq_app/models/common_functions.dart';
import 'package:tafawoq_app/models/update_user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../utils/form_helpers.dart';
import 'auth_screen.dart';
import 'verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

Future<UpdateUserModel> signUp(
    String firstName, String lastName, String email, String password) async {
  const String apiUrl = "$BASE_URL/api/signup";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    throw Exception('Failed to load data');
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool hidePassword = true;
  bool _isLoading = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!globalFormKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      final UpdateUserModel user = await signUp(
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          _passwordController.text);

      if (user.emailVerification == 'enable') {
        if (user.message ==
            "You have already signed up. Please check your inbox to verify your email address") {
          Navigator.of(context).pushNamed(VerificationScreen.routeName,
              arguments: _emailController.text);
          CommonFunctions.showSuccessToast(user.message.toString());
        } else {
          Navigator.of(context).pushNamed(VerificationScreen.routeName,
              arguments: _emailController.text);
          CommonFunctions.showSuccessToast(
            user.message.toString(),
          );
        }
      } else {
        Navigator.of(context).pushNamed(AuthScreen.routeName);
        CommonFunctions.showSuccessToast(
            AppLocalizations.of(context)!.signupSuccessful);
      }
    } catch (error) {
      final errorMsg = AppLocalizations.of(context)!.couldNotRegister;
      // print(error);
      CommonFunctions.showErrorDialog(errorMsg, context);
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
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: kBackgroundColor,
                          child: Image.asset(
                            'assets/images/do_login.png',
                            height: 65,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.signUp,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 17.0, bottom: 5.0),
                            child: Text(
                              AppLocalizations.of(context)!.firstName,
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
                              hintText: AppLocalizations.of(context)!.firstName,
                              fillColor: kBackgroundColor,
                              borderColor: Colors.white,
                              focusedBorderColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: kTextLowBlackColor,
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            controller: _firstNameController,
                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .firstNameRequired;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _authData['email'] = value.toString();
                              _firstNameController.text = value as String;
                            },
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 17.0, bottom: 5.0),
                            child: Text(
                              AppLocalizations.of(context)!.lastName,
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
                              hintText: AppLocalizations.of(context)!.lastName,
                              fillColor: kBackgroundColor,
                              borderColor: Colors.white,
                              focusedBorderColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: kTextLowBlackColor,
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            controller: _lastNameController,
                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .lastNameRequired;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _authData['email'] = value.toString();
                              _lastNameController.text = value as String;
                            },
                          ),
                        ),
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
                              // _authData['email'] = value.toString();
                              _emailController.text = value as String;
                            },
                          ),
                        ),
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
                              // _authData['password'] = input.toString();
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
                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15,
                                      top: 10,
                                      bottom: 10),
                                  child: MaterialButton(
                                    elevation: 0,
                                    onPressed: _submit,
                                    color: kPrimaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
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
                                          AppLocalizations.of(context)!.signUp,
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
                        const SizedBox(height: 5),
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
                    AppLocalizations.of(context)!.alreadyHaveAccount,
                    style: const TextStyle(
                      color: kTextLowBlackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AuthScreen.routeName);
                    },
                    child: Text(
                      ' ${AppLocalizations.of(context)!.signIn}',
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
