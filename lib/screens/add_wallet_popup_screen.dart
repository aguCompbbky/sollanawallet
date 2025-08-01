import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/screens/drawer_menu.dart';
import 'package:walletsolana/screens/wallet_list.dart';
import 'package:walletsolana/utilities/image_utilities.dart';
import 'package:walletsolana/utilities/text_utilities.dart';
import 'package:lottie/lottie.dart';
class ChangeWalletPopup extends StatelessWidget {
  const ChangeWalletPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return ListTile(
          leading: DrawerIconWidget(image: ImageUtilities.iconWallet),
          title: TextDrawerWigdet(text: "Change Wallet", color: Colors.black),
          onTap: () {
            // Alt cüzdanları almak için event gönderiyoruz
            context.read<WalletBloc>().add(GetUserWalletsEvent());

            showDialog(
              context: context,
              builder: (context) {
                return BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, walletState) {
                    if (walletState is WalletListState) {
                      final wallets = walletState.wallets;

                      return AlertDialog(
                        scrollable: true,
                        title: Align(
                          alignment: Alignment.center,
                          child: TitleLargeWigdet(
                            text: "Change Wallet",
                            color: Colors.black,
                          ),
                        ),
                        content: SizedBox(
                          height: 300,
                          width: 300,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var wallet in wallets)
                                  ListTile(
                                    title: Text(wallet.publicKey),
                                    onTap: () {
                                      // Seçilen cüzdanı aktif cüzdan olarak seçiyoruz
                                      context.read<WalletBloc>().add(
                                        SwitchActiveWalletEvent(
                                          publicKey: wallet.publicKey,
                                        ),
                                      );
                                      Navigator.pop(context); // Dialogu kapat
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset("assets/lottie/Lonely404.json"),
                            Text("Page is not found.")
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

