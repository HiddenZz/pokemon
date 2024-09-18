import 'package:freezed_annotation/freezed_annotation.dart';
part 'stripes.freezed.dart';
part 'stripes.g.dart';

@freezed
class Stripes with _$Stripes {
  factory Stripes({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'front_default') String? frontDefault,
  }) = _Stripes;

  factory Stripes.fromJson(Map<String, dynamic> json) => _$StripesFromJson(json);
}
