import 'package:json_annotation/json_annotation.dart';
part 'malin_gidecegi_yer_model.g.dart';

@JsonSerializable()
class GidecegiYer {
  String type;
  String name;
  String isletmeTuru;
  String isletmeTuruId;
  String isyeriId;
  String adres;
  GidecegiYer(
      {required this.type,
      required this.name,
      required this.isletmeTuru,
      required this.isletmeTuruId,
      required this.isyeriId,
      required this.adres});
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GidecegiYer &&
            runtimeType == other.runtimeType &&
            type == other.type &&
            name == other.name;
  }

  Map<String, Object?> toJson() => _$GidecegiYerToJson(this);

  @override
  int get hashCode => Object.hash(type, name);
}
