
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walletsolana/models/wallet_model.dart';


part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String email;
  final String uid;
  final List<WalletModel> wallet;


  UserModel({
    required this.email,
    required this.uid,
    required this.wallet,
  });

    // JSON'dan UserModel nesnesi oluşturmak için fromJson fonksiyonu
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // JSON'a dönüştürmek için toJson fonksiyonu
  Map<String, dynamic> toJson() => _$UserModelToJson(this);



}



