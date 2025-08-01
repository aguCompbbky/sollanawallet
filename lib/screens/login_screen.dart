import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:walletsolana/bloc/auth/auth_bloc.dart';
import 'package:walletsolana/bloc/auth/auth_event.dart';
import 'package:walletsolana/bloc/auth/auth_state.dart';
import 'package:walletsolana/services/firestore_service.dart';
import 'package:walletsolana/services/wallet_services.dart';
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
  final _emailController = TextEditingController(text: "sifreli24@gmail.com");
  final _passwordController = TextEditingController(text: "123456");
  WalletService walletService =
      WalletService(); // geçici olarak bussinessdan çekildi

  @override
  void dispose() {
    //memory leakları engeller birde controllerların set edilmiş halde kalmasını önler.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(FireStoreService()),
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, //klavyenin taşıp bottom overflow olmasını engelliyor.
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
                      controller: _emailController,
                    ),
                    _gap24px(),
                    PasswordFormWidget(
                      text: "Password",
                      controller: _passwordController,
                    ),
                    _gap24px(),
                    _gap24px(),
                    _gap24px(),
                  ],
                ),
              ),

              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is LoginedGoogleState) {
                    context.go("/main");
                  } else if (state is LoginedState) {
                    context.go("/main");
                    await walletService.initWalletForUser(state.email);
                    print(state);
                  } else if (state is LoginErrorState) {
                    Fluttertoast.showToast(msg: "Invalid account informations");
                  }
                },
                builder: (context, state) {
                  final googleImg = "assets/images/google.png";
                  final appleImg = "assets/images/apple.png";
                  final facebookImg = "assets/images/facebook.png";
                  final loginGoogleHeight = 36.0;
                  
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
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              ); // eventi başlat
                            },
                          ),
                        ),
                        _gap72px(),
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
                                child: Padding(
                                  padding: PaddingUtilities.paddingAll20,
                                  child: Image.asset(
                                    googleImg,
                                    width: loginGoogleHeight,
                                    height: loginGoogleHeight,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              //color: Colors.white,
                              child: Padding(
                                padding: PaddingUtilities.paddingAll20,
                                child: Image.asset(
                                  appleImg,
                                  width: loginGoogleHeight,
                                  height: loginGoogleHeight,
                                ),
                              ),
                            ),

                            SizedBox(
                              //color: Colors.white,
                              child: Padding(
                                padding: PaddingUtilities.paddingAll20,
                                child: Image.asset(
                                  facebookImg,
                                  width: loginGoogleHeight,
                                  height: loginGoogleHeight,
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
  SizedBox _gap72px() => SizedBox(height: 72);
}
