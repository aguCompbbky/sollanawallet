import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walletsolana/bloc/profile/profile_bloc.dart';
import 'package:walletsolana/bloc/profile/profile_event.dart';
import 'package:walletsolana/bloc/profile/profile_state.dart';
import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/services/pp_service.dart';
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
    const String pp = "assets/images/pp.png";
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
            child: TitleMediumWigdet(text: "Name Surname", color: Colors.black),
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
context.go("/transfer");          },
        ),

        Divider(),

        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(onPressed: () {}, child: Text("log out")),
        ),
      ],
    );
  }
}

class _PPWidget extends StatelessWidget {
  const _PPWidget({required this.pp});

  final String pp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(PpService()),

      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: PaddingUtilities.paddingLeft / 1.2,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String? profileUrl;
              if (state is SuccessfulState) {
                profileUrl = state.photoUrl;
                
              }
              return IconButton(
                onPressed: () async {
                  print("statee"+state.toString());
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (image != null) {
                    final Uint8List imageBytes = await image.readAsBytes();
                    context.read<ProfileBloc>().add(SavePPEvent(imageBytes));
                  }
                },
                icon: CircleAvatar(
                  radius: 64,
                  child: profileUrl != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(profileUrl),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage(
                            pp,
                          ), // yedek default görsel
                        ),
                ),
              );
            },
          ),
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
  const _ViewProfileTextWidget({super.key});

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
