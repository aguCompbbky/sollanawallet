// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
  publicKey: json['publicKey'] as String,
  mnemonic: json['mnemonic'] as String,
);

Map<String, dynamic> _$WalletModelToJson(WalletModel instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'mnemonic': instance.mnemonic,
    };
