import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/screens/main_screen.dart';
import 'package:walletsolana/services/wallet_services.dart';
import 'package:walletsolana/utilities/button_utilities.dart';
import 'package:walletsolana/utilities/color_utilities.dart';
import 'package:walletsolana/utilities/form_utilities.dart';
import 'package:walletsolana/utilities/padding_utilities.dart';
import 'package:walletsolana/utilities/text_utilities.dart';

WalletService walletService = WalletService();

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(ShowPKEvent());
  }

  String? balance;
  final addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Expanded(
            child: Column(
              children: [
                BalanceWidget(balance ?? "999"),
                Spacer(),
                Padding(
                  padding: PaddingUtilities.paddingRightLeft,
                  child: Column(
                    children: [
                      EmailFormWidget(
                        text: 'Write the target address',
                        controller: addressController,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: PaddingUtilities.paddingTopBottom,
                  child: ButtonWidget(
                    buttonBackgroundColor: ColorUtilities.buttonBackgroundColor,
                    text: "send",
                    onpressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
    
    );
  }
}

class BalanceWidget extends StatelessWidget {
  const BalanceWidget(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        print("balancesin statesi: $state");
        state is GetPKState;
        print("balancesin statesi: $state");
        if (state is GetPKState) {
          final publicKey = state.pk;
          print("state.pk: ${state.pk}");
          context.read<WalletBloc>().add(
            GetSolBalanceEvent(publicKey: publicKey.toString()),
          );
        }
        if (state is GetSolBalanceState) {
          final sol = state.balance / 1e9;
          return _buildCard("${sol.toStringAsFixed(4)} SOL");
        }

        return _buildCard(label);
      },
    );
  }

  Padding _buildCard(String label) {
    return Padding(
      padding: PaddingUtilities.paddingTop * 2,
      child: SizedBox(
        height: 252,
        width: 352,
        child: Card(
          color: Colors.amber,
          child: Column(
            children: [
              Padding(
                padding: PaddingUtilities.paddingTopBottom * 2,
                child: TitleMediumWigdet(
                  text: 'Solana Balance ',
                  color: Colors.white,
                ),
              ),
              TitleLargeWigdet(text: label, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
