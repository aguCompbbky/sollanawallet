import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/services/wallet_services.dart';
import 'package:walletsolana/utilities/button_utilities.dart';
import 'package:walletsolana/utilities/color_utilities.dart';
import 'package:walletsolana/utilities/form_utilities.dart';
import 'package:walletsolana/utilities/padding_utilities.dart';
import 'package:walletsolana/utilities/text_utilities.dart';

WalletService walletService = WalletService();

class TransferScreen extends StatefulWidget {
  final String? pk;
  const TransferScreen({super.key, required this.pk});
  

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  void initState() {
    print(widget.pk.toString());
    super.initState();
    context.read<WalletBloc>().add(ShowPKEvent());
    context.read<WalletBloc>().add(GetSolBalanceEvent(publicKey: widget.pk ??""));
  }

  String? balance;
  final addressController = TextEditingController();
  final amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.go("/main");
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
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
                      SizedBox(height: 70),
                      Padding(
                        padding: PaddingUtilities.paddingRightLeft * 5,
                        child: EmailFormWidget(
                          text: "Enter the amount",
                          controller: amountController,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    return Padding(
                      padding: PaddingUtilities.paddingTopBottom,
                      child: ButtonWidget(
                        buttonBackgroundColor:
                            ColorUtilities.buttonBackgroundColor,
                        text: "send",
                        onpressed: _transfer
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

  void _transfer() {
    final receiver = addressController.text.trim();
    final solana = double.tryParse(amountController.text.trim());//1

    if (receiver.isEmpty || solana == null || solana <= 0) {
      print("para yok");
      return;
    }

    final state = context.read<WalletBloc>().state;
    print("transfer oncesi state $state");
    if (state is GetSolBalanceState) {
      final sender = state.publicKey;

      final lamportAmount = (solana * 1000000000).round();//lamporta cevir

      context.read<WalletBloc>().add(
        TransferSOLEvent(
          senderPubKey: sender,
          reciverPubKey: receiver,
          amount: lamportAmount,
        ),
      );
    } else {
      print("Public key not loaded yet.");
    }
  }




}

class BalanceWidget extends StatelessWidget {
  const BalanceWidget(this.solText, {super.key});
  final String solText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        print("balancesin statesi: $state");
        if (state is GetSolBalanceState) {
          final sol = state.balance / 1000000000;
          return _buildCard(
            "${sol.toStringAsFixed(3)} SOL",
          ); //virgülden sonraki 3 basamağı göster
        }

        return _buildCard(solText);
      },
    );
  }

  Padding _buildCard(String solText) {
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
                  text: 'Solana Balance',
                  color: Colors.white,
                ),
              ),
              TitleLargeWigdet(text: solText, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }


}
