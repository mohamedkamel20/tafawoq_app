// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:tafawoq_app/models/common_functions.dart';
import 'package:tafawoq_app/providers/auth.dart';
import 'package:tafawoq_app/widgets/app_bar_two.dart';
import 'package:tafawoq_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../l10n/app_localizations.dart';

class EditPasswordScreen extends StatefulWidget {
  static const routeName = '/edit-password';
  const EditPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool hidePassword = true;
  var _isLoading = false;
  final Map<String, String> _passwordData = {
    'oldPassword': '',
    'newPassword': '',
  };
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).updateUserPassword(
          _passwordData['oldPassword'].toString(),
          _passwordData['newPassword'].toString());

      CommonFunctions.showSuccessToast(
          AppLocalizations.of(context)?.passwordUpdatedSuccessfully ??
              'Password updated Successfully');
    } on HttpException {
      var errorMsg = AppLocalizations.of(context)?.passwordUpdateFailed ??
          'Password Update failed';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      // print(error);
      final errorMsg =
          AppLocalizations.of(context)?.passwordUpdateFailedExclamation ??
              'Password Update failed!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: kDefaultInputBorder,
      focusedBorder: kDefaultFocusInputBorder,
      focusedErrorBorder: kDefaultFocusErrorBorder,
      errorBorder: kDefaultFocusErrorBorder,
      filled: true,
      hintStyle: const TextStyle(color: kFormInputColor),
      hintText: hintext,
      fillColor: Colors.white70,
      prefixIcon: Icon(
        iconData,
        color: kFormInputColor,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: AppLocalizations.of(context)?.updatePassword ??
                      'Update Password',
                  colors: kTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: kPrimaryColor.withOpacity(0.7)),
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                AppLocalizations.of(context)?.currentPassword ??
                                    'Current Password',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            style: const TextStyle(fontSize: 16),
                            decoration: getInputDecoration(
                              AppLocalizations.of(context)?.currentPassword ??
                                  'Current Password',
                              Icons.vpn_key,
                            ),
                            obscureText: hidePassword,
                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)
                                        ?.cannotBeEmpty ??
                                    'Can not be empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _passwordData['oldPassword'] = value.toString();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                AppLocalizations.of(context)?.newPassword ??
                                    'New Password',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            style: const TextStyle(fontSize: 16),
                            decoration: getInputDecoration(
                              AppLocalizations.of(context)?.newPassword ??
                                  'New Password',
                              Icons.vpn_key,
                            ),
                            obscureText: hidePassword,
                            controller: _passwordController,
                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return AppLocalizations.of(context)
                                        ?.passwordTooShort ??
                                    'Password is too short!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _passwordData['newPassword'] = value.toString();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                AppLocalizations.of(context)?.confirmPassword ??
                                    'Confirm Password',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            style: const TextStyle(fontSize: 16),
                            decoration: getInputDecoration(
                              AppLocalizations.of(context)?.confirmPassword ??
                                  'Confirm Password',
                              Icons.vpn_key,
                            ),
                            obscureText: hidePassword,
                            // ignore: missing_return
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return AppLocalizations.of(context)
                                        ?.passwordsDoNotMatch ??
                                    'Passwords do not match!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: MaterialButton(
                              onPressed: _submit,
                              color: kPrimaryColor,
                              textColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              splashColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                side: const BorderSide(color: kPrimaryColor),
                              ),
                              child: Text(
                                AppLocalizations.of(context)?.updateNow ??
                                    'Update Now',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
