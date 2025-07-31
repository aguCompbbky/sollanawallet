
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/main.dart';

import 'package:walletsolana/models/wallet_model.dart';
import 'package:walletsolana/screens/add_wallet_popup_screen.dart';
import 'package:walletsolana/services/encryption_service.dart';
import 'package:walletsolana/utilities/image_utilities.dart';
import 'package:walletsolana/utilities/padding_utilities.dart';
import 'package:walletsolana/utilities/text_utilities.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(padding: PaddingUtilities.paddingTop),
          MenuItems(),
        ],
      ),
    );
  }
}

class MenuItems extends StatelessWidget {
  const MenuItems({super.key});
  

  @override
  Widget build(BuildContext context) {
    EncryptionService encrypt = EncryptionService();
    const String pp = "assets/images/pp.png";
    String? pk;
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state is GetPKState) {
          
          pk = state.pk;
        }
        return Column(
          children: [
            TitleLargeWigdet(
              text: TextUtilities.solidium,
              color: Colors.deepPurple,
            ),

            _PPWidget(pp: pp),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: PaddingUtilities.paddingLeft,
                child: TitleMediumWigdet(
                  text: state.user!.email ?? "Name Surname",
                  color: Colors.black,
                ),
              ),
            ),

            _ViewProfileTextWidget(),
            Divider(),

            ListTile(
              leading: DrawerIconWidget(image: ImageUtilities.phontomImage),
              title: TextDrawerWigdet(
                text: 'Connect With Phantom',
                color: Colors.black,
              ),
              onTap: () {
                context.read<WalletBloc>().add(
                  ConnectPhantomEvent(authToken: '', publicKey: null),
                );
              },
            ),

            ListTile(
              leading: DrawerIconWidget(image: ImageUtilities.iconSolflare),
              title: TextDrawerWigdet(
                text: "Connect with Solflare",
                color: Colors.black,
              ),
              onTap: () {},
            ),

            ListTile(
              leading: DrawerIconWidget(image: ImageUtilities.iconNFTImage),
              title: TextDrawerWigdet(text: "My NFT's", color: Colors.black),
              onTap: () {},
            ),

            ListTile(
              leading: DrawerIconWidget(image: ImageUtilities.iconExplore),
              title: TextDrawerWigdet(text: "Transfer", color: Colors.black),
              onTap: () {
                context.go("/transfer", extra: {'q': pk});
              },
            ),

            Divider(),

            ChangeWalletPopup(),

            ListTile(
              leading: DrawerIconWidget(image: ImageUtilities.iconPlus),
              title: TextDrawerWigdet(
                text: "Add New Wallet",
                color: Colors.black,
              ),
              onTap: () async {
                //wallet ekle
                
               
                final newMnemonic = await walletService
                    .generateMnemonic();  
                final newWallet = await walletService.createWalletFromMnemonic(
                  newMnemonic,
                ); 
                final encryptedMnemonic = encrypt.encryptMnemonic(newMnemonic);
                final newPublicKey = newWallet.address; 
                final newMnemonicValue = encryptedMnemonic.base64; 

                
                final wallet = WalletModel(
                  publicKey: newPublicKey,
                  mnemonic: newMnemonicValue,
                );

               
                context.read<WalletBloc>().add(AddWalletEvent(wallet: wallet));


                

                
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      insetPadding: PaddingUtilities.paddingTopBottom,
                      content: TitleLargeWigdet(
                        text: "Wallet was added",
                        color: Colors.black,
                      ),
                    );
                  },
                );

                
              },
            ),

           
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(onPressed: () {}, child: Text("log out")),
            ),
          ],
        );
      },
    );
  }
}

class _PPWidget extends StatelessWidget {
  const _PPWidget({required this.pp});

  final String pp;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: PaddingUtilities.paddingLeft / 1.2,
        child: CircleAvatar(
          radius: 64,
          child: CircleAvatar(radius: 64, backgroundImage: AssetImage(pp)),
        ),
      ),
    );
  }
}

class DrawerIconWidget extends StatelessWidget {
  const DrawerIconWidget({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Image.asset(image, width: 48, height: 48);
  }
}

class _ViewProfileTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: PaddingUtilities.paddingLeft,
        child: TextSmallWigdet(text: "View Profile", color: Colors.black),
      ),
    );
  }
}
