import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:walletsolana/bloc/auth/auth_bloc.dart';
import 'package:walletsolana/bloc/auth/auth_event.dart';
import 'package:walletsolana/bloc/auth/auth_state.dart';

import 'package:walletsolana/services/firestore_service.dart';
import 'package:walletsolana/utilities/button_utilities.dart';
import 'package:walletsolana/utilities/color_utilities.dart';
import 'package:walletsolana/utilities/form_utilities.dart';
import 'package:walletsolana/utilities/padding_utilities.dart';
import 'package:walletsolana/utilities/text_utilities.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(FireStoreService()),
      child: Scaffold(
        appBar: AppBar(),

        body: Center(
          child: Column(
            children: [
              Padding(
                padding: PaddingUtilities.paddingRight,
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TitleMediumWigdet(
                      text: TextUtilities.solidium,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: PaddingUtilities.paddingRightLeft,
                child: Column(
                  children: [
                    SizedBox(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TitleMediumWigdet(
                          text: TextUtilities.welcome,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    _gap24px(),
                    EmailFormWidget(text: "Name", controller: nameController),
                    _gap24px(),
                    EmailFormWidget(
                      text: "E-mail",
                      controller: emailController,
                    ),
                    _gap24px(),
                    EmailFormWidget(
                      text: "Username",
                      controller: usernameController,
                    ),
                    _gap24px(),
                    PasswordFormWidget(
                      text: "Password",
                      controller: passwordController,
                    ),
                    _gap24px(),
                    PasswordFormWidget(
                      text: "Confirm Password",
                      controller: confirmPasswordController,
                    ),
                    _gap24px(),
                    _gap24px(),
                    _gap24px(),
                  ],
                ),
              ),

              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is RegisteredState) {
                    Fluttertoast.showToast(msg: "successfull register");
                    context.go("/mnemonic");
                  } else if (state is LoginErrorState) {
                    Fluttertoast.showToast(msg: "unsuccessfull register");
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: PaddingUtilities.paddingRightLeft,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 52,
                          width: 327,
                          child: ButtonWidget(
                            buttonBackgroundColor:
                                ColorUtilities.buttonBackgroundColor,

                            text: TextUtilities.singUp,
                            onpressed: () {
                              if (passwordController.text ==
                                      confirmPasswordController.text &&
                                  passwordController.text.length >= 6) {
                                context.read<AuthBloc>().add(
                                  RegisterWithEmailEvent(
                                    emailController.text,
                                    passwordController.text,
                                    nameController.text,
                                    usernameController.text,
                                  ),
                                );

                                print(emailController.text);
                              } else if (passwordController.text.length < 6) {
                                Fluttertoast.showToast(

                                  msg: "Password length must be minimum 6",
                                );
                              } else if (passwordController.text !=
                                  confirmPasswordController.text) {
                                    Fluttertoast.showToast(msg: "Passwords do not macth");
                                
                              }
                            },
                          ),
                        ),
                        _gap24px(),
                        _gap24px(),
                        _gap24px(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (passwordController.text == confirmPasswordController.text) {
    } else {}
  }
}

SizedBox _gap24px() => SizedBox(height: 24);
