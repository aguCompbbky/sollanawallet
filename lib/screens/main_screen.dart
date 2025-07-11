import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
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
  final WalletService walletService = WalletService();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const String assetPath = "assets/images/mainPageBackgroung.jpg";

    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset : false,
          body: Container(
            width: screenSize
                .width, //arka plan resmi ekranı kaplasın diye böyle kullanmıştım
            height: screenSize.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(assetPath),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: PaddingUtilities.paddingTop*3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TitleLargeWigdet(
                      text: TextUtilities.solidium,
                      color: Colors.white,
                    ),
                    SizedBox(height: 24),
                    _SearchBarWidget(),
                    PublicKey(),
                    _PhantomWidget(), 
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchController = TextEditingController();
    return Padding(
      padding: PaddingUtilities.paddingRightLeft * 2,
      child: EmailFormWidget(text: "Search", controller: SearchController),
    );
  }
}

class _PhantomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String phontomImage = "assets/images/phantom.png";
    return IconButton(
      onPressed: () async {
        print("buton phantom");
        context.read<WalletBloc>().add(
          ConnectPhantomEvent(authToken: '', publicKey: null),
        );
      },
      icon: Image.asset(phontomImage),
    );
  }
}

class PublicKey extends StatelessWidget {
  const PublicKey({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        String? pk;

        if (state is GetPKState) {
          pk = state.pk;
        }

        context.read<WalletBloc>().add(ShowPKEvent());

        return Column(
          children: [
            Padding(
              padding: PaddingUtilities.paddingTop / 2,
              child: TitleMediumWigdet(
                text: "Copy the wallet adress",
                color: Colors.white,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: PaddingUtilities.paddingRightLeft,
                    height: 18,
                    child: TextSmallWigdet(
                      color: const Color.fromARGB(255, 210, 210, 210),
                      text: pk ?? "deneme",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (pk != null) {
                      Clipboard.setData(ClipboardData(text: pk));
                    }
                  },

                  icon: Icon(Icons.copy),
                ),
              ],
            ),

            Padding(
              padding: PaddingUtilities.paddingTop / 2,
              child: TitleMediumWigdet(
                text: "Connect to Wallets",
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
