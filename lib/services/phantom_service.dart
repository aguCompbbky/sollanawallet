// import 'package:flutter/material.dart';
// import 'package:solana_wallet_adapter/solana_wallet_adapter.dart';
// class PhantomService extends StatefulWidget {
// static final Cluster cluster = Cluster.devnet;

//   @override
//   State<PhantomService> createState() => _PhantomServiceState();
// }

// class _PhantomServiceState extends State<PhantomService> {
//   // Future representing the initialization process
// late final Future<void> _future;

// // Status variable to store connection status
// String? _status;

// // SolanaWalletAdapter instance for wallet integration
// final SolanaWalletAdapter adapter = SolanaWalletAdapter(
//   AppIdentity(
//     uri: Uri.https('example.com'),  // App URI
//     icon: Uri.parse('favicon.png'), // App icon URI
//     name: 'Example App',  // App name
//   ),
//   cluster: PhantomService.cluster,  // Solana cluster
//   hostAuthority: null,  // Host authority (optional)
// );

// // Initialize the state
// @override
// void initState() {
//   super.initState();
//   _future = SolanaWalletAdapter.initialize();  // Initialize the SolanaWalletAdapter
// }

// // Function to connect the wallet
// Future<void> _connect() async {
//   if (!adapter.isAuthorized) {
//     await adapter.authorize(
//         walletUriBase: adapter.store.apps[0].walletUriBase);  // Authorize the wallet
//     setState(() {});
//   }
// }

// // Function to disconnect the wallet
// Future<void> _disconnect() async {
//   if (adapter.isAuthorized) {
//     await adapter.deauthorize();  // Deauthorize the wallet
//     setState(() {});
//   }
// }

//   @override
//   Widget build(BuildContext context) {

//     throw UnimplementedError();
//   } 
// }

