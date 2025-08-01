import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walletsolana/bloc/wallet/wallet_bloc.dart';
import 'package:walletsolana/firebase_options.dart';
import 'package:walletsolana/services/wallet_services.dart';
import 'package:walletsolana/utilities/router_manager.dart';
import 'package:walletsolana/utilities/text_utilities.dart';

final walletService = WalletService();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);

  runApp(MyApp());
}

final GoRouter _router = RouterManager.router();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletBloc(walletService),
      child: MaterialApp.router(
        routerConfig: _router,
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme().copyWith(
            titleMedium: TextStyle(
              fontSize: TextUtilities.mediumTitleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
