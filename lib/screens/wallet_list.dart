import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/models/wallet_model.dart';

class WalletList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state is WalletLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WalletErrorState) {
          return Center(child: Text(state.error));
        } else if (state is WalletListState) {
          final wallets = state.wallets;
          return ListView.builder(
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return ListTile(
                title: Text(wallet.publicKey),
                subtitle: Text("Mnemonic: ${wallet.mnemonic}"),
                onTap: () {
                  // Cüzdanı aktif yapmak için BLoC'a event gönder
                  context.read<WalletBloc>().add(SwitchActiveWalletEvent(publicKey: wallet.publicKey));
                },
              );
            },
          );
        } else {
          return const Center(child: Text("No wallets available"));
        }
      },
    );
  }
}

class WalletListState extends WalletState {
  final List<WalletModel> wallets; // Alt cüzdanları tutacak liste

  WalletListState({required this.wallets, required String publicKey})
      : super(publicKey: publicKey); // Alt cüzdanlar ile aktif cüzdan bilgisi

}

class WalletLoadingState {
}