import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/services/wallet_services.dart';
import 'package:walletsolana/utilities/form_utilities.dart';
import 'package:walletsolana/utilities/padding_utilities.dart';
import 'package:walletsolana/utilities/text_utilities.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SearchController = TextEditingController();
  final WalletService walletService = WalletService();

  String? pk;
  late var email;

  @override
  void initState() {
    super.initState();
    email = FirebaseAuth.instance.currentUser?.email ?? '';
    fetchPublickey();
  }

  Future<String?> fetchPublickey() async {
    final pkey = await walletService.getAddress(email);
    setState(() {
      pk = pkey;
    });
    return "qqqq";
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const String assetPath = "assets/images/mainPageBackgroung.jpg";
    const String metamaskImage = "assets/images/metamask.png";
    const String phontomImage = "assets/images/phantom.png";
    return BlocProvider(
      create: (context) => WalletBloc(),
      child: Scaffold(
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(assetPath),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              children: [
                TitleLargeWigdet(
                  text: TextUtilities.solidium,
                  color: Colors.white,
                ),
                SizedBox(height: 24),
                Padding(
                  padding: PaddingUtilities.paddingRightLeft * 2,
                  child: EmailFormWidget(
                    text: "Search",
                    controller: SearchController,
                  ),
                ),
                BlocConsumer<WalletBloc, WalletState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Column(
                      children: [
                        Padding(
                          padding: PaddingUtilities.paddingTop/2,
                          child: TitleMediumWigdet(text: "Copy the wallet adress", color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            Expanded(
                              child: Container(
                                margin: PaddingUtilities.paddingRightLeft,
                                height: 18,
                                child: TextSmallWigdet(color: const Color.fromARGB(255, 210, 210, 210), text:pk ??"deneme" ,)
                               
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (pk != null) {
                                  Clipboard.setData(ClipboardData(text: pk!));
                                }
                              },
                        
                              icon: Icon(Icons.copy),
                            ),
                          ],
                        ),
                        Padding(
                          padding: PaddingUtilities.paddingTop/2,
                          child: TitleMediumWigdet(text: "Connect to Wallets", color: Colors.white),
                        ),

                      ],
                    );
                  },
                ),
                IconButton(onPressed: () {}, icon: Image.asset(metamaskImage)),//süs
                IconButton(onPressed: () {}, icon: Image.asset(phontomImage)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
