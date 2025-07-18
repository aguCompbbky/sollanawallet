
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:walletsolana/services/encryption_service.dart';
import 'package:walletsolana/services/firestore_service.dart';
import 'package:walletsolana/utilities/button_utilities.dart';
import 'package:walletsolana/utilities/padding_utilities.dart';
import 'package:go_router/go_router.dart';


class MnemonicScreen extends StatefulWidget {
  const MnemonicScreen({super.key});

  @override
  State<MnemonicScreen> createState() => _MnemonicScreenState();
}

class _MnemonicScreenState extends State<MnemonicScreen> {
  FireStoreService db = FireStoreService();

  String? mnemonic;
  List<String> words = [];
  EncryptionService encryptionService = EncryptionService();

  @override
  void initState() {
    
    print("sayfaya girdi");
    super.initState();
    _loadMnemonic();
  }

  Future<void> _loadMnemonic() async {
    final locked = await db.getMnemonicFromFirebase();//sifreli dondurdu //bu String grliyor 
    final encrypted = encrypt.Encrypted.fromBase64(locked); // Stringi Encrypted a dönüştürüyoz
    final result = encryptionService.decryptMnemonic(encrypted); // bize string lazım zaten decrypt de string veriyor
    setState((){
      mnemonic = result;
      words = mnemonic!.split(' ');
       
    });
  }

  @override
  Widget build(BuildContext context) {


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
