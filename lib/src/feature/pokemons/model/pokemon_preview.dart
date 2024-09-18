import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon/src/feature/pokemons/model/stripes.dart';
part 'pokemon_preview.freezed.dart';
part 'pokemon_preview.g.dart';

@freezed
class PokemonPreview with _$PokemonPreview {
  factory PokemonPreview({
    String? name,
    required Stripes sprites,
    required int id,
  }) = _PokemonPreview;

  factory PokemonPreview.fromJson(Map<String, dynamic> json) => _$PokemonPreviewFromJson(json);
}
