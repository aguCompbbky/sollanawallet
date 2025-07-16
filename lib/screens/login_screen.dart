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

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController(text: "galaksilife8@gmail.com");
  final passwordController = TextEditingController(text:"123456" );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(FireStoreService()),
      child: Scaffold(
        resizeToAvoidBottomInset: false, //klavyenin taşıp bottom overflow olmasını engelliyor.
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
                          text: TextUtilities.welcomeBack,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    _gap24px(),
                    EmailFormWidget(
                      text: "E-mail",
                      controller: emailController,
                    ),
                    _gap24px(),
                    PasswordFormWidget(
                      text: "Password",
                      controller: passwordController,
                    ),
                    _gap24px(),
                    _gap24px(),
                    _gap24px(),
                  ],
                ),
              ),

              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoginedState) {
                    context.go("/main");
                    print(state);
                  } else if (state is LoginErrorState) {
                    Fluttertoast.showToast(msg: "Invalid account informations");
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
                            buttonBackgroundColor: ColorUtilities.reverseColor(
                              ColorUtilities.buttonBackgroundColor,
                            ),
                            text: TextUtilities.logIn,
                            onpressed: () {
                              context.read<AuthBloc>().add(
                                LoginWithEmailEvent(
                                  emailController.text,
                                  passwordController.text,
                                ),
                              ); // eventi başlat
                            },
                          ),
                        ),
                        _gap24px(),
                        _gap24px(),
                        _gap24px(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                  LoginWithGoogleEvent(),
                                );
                              }, // google auth
                              icon: SizedBox(
                                //color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.asset(
                                    "assets/images/google.png",
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              //color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "assets/images/apple.png",
                                  width: 36,
                                  height: 36,
                                ),
                              ),
                            ),

                            SizedBox(
                              //color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "assets/images/facebook.png",
                                  width: 36,
                                  height: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
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

  SizedBox _gap24px() => SizedBox(height: 24);
}
