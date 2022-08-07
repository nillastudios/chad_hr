// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Perks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Perks _$PerksFromJson(Map<String, dynamic> json) => Perks()
  ..redeemer =
      (json['redeemer'] as List<dynamic>?)?.map((e) => e as String?).toList()
  ..perk = json['perk'] as String?
  ..expireDate = json['expireDate'] == null
      ? null
      : DateTime.parse(json['expireDate'] as String);

Map<String, dynamic> _$PerksToJson(Perks instance) => <String, dynamic>{
      'redeemer': instance.redeemer,
      'perk': instance.perk,
      'expireDate': instance.expireDate?.toIso8601String(),
    };
