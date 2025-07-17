import 'package:flutter/material.dart';
import 'package:walletsolana/services/wallet_services.dart';
import 'package:walletsolana/utilities/button_utilities.dart';
import 'package:walletsolana/utilities/padding_utilities.dart';
import 'package:go_router/go_router.dart';


class MnemonicScreen extends StatefulWidget {
  const MnemonicScreen({super.key});

  @override
  State<MnemonicScreen> createState() => _MnemonicScreenState();
}

class _MnemonicScreenState extends State<MnemonicScreen> {
  final WalletService walletService = WalletService();
  String? mnemonic;
  List<String> words = [];

  @override
  void initState() {
    print("sayfaya girdi");
    super.initState();
    _loadMnemonic();
  }

  Future<void> _loadMnemonic() async {
    final result = await walletService.generateMnemonic(); // bura silinecek
    setState(() {
      mnemonic = result;
      words = result.split(' ');
       
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (mnemonic == null) {
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }

    return Scaffold(
      body: Padding(
        padding: PaddingUtilities.paddingRightLeft,
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${index + 1}. ${words[index]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            ButtonWidget(
              buttonBackgroundColor: Colors.black,
              text: "I have saved my words",
              onpressed: () async {
                print("buton çalıştı");
                context.go('/login');
                //await walletService.createAndStoreNewWallet();
              },
            ),
          ],
        ),
      ),
    );
  }
}
