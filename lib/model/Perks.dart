import 'package:json_annotation/json_annotation.dart';
part 'Perks.g.dart';

@JsonSerializable(explicitToJson: true)
class Perks {
  List<String?>? redeemer;
  String? perk;
  DateTime? expireDate;

  Perks();

  factory Perks.fromJson(Map<String, dynamic> data) => _$PerksFromJson(data);

  Map<String, dynamic> toJson() => _$PerksToJson(this);
}
