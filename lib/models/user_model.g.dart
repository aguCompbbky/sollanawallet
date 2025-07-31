// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  email: json['email'] as String,
  uid: json['uid'] as String,
  wallet: (json['wallet'] as List<dynamic>)
      .map((e) => WalletModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'email': instance.email,
  'uid': instance.uid,
  'wallet': instance.wallet,
};
