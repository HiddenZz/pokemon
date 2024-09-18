import 'package:pokemon/src/feature/pokemons/data/pokemos_network_provider.dart';
import 'package:pokemon/src/feature/pokemons/model/pokemon_preview.dart';

abstract interface class PokemonsRepository {
  Future<PokemonPreview> fetchPokemon(int id);

  Stream<PokemonPreview> fetchPokemonGroup(int count);
}

final class PokemosRepositoryImpl implements PokemonsRepository {
  PokemosRepositoryImpl({required IPokemonsNetworkDataProvider networkDataProvider})
      : _networkDataProvider = networkDataProvider;

  final IPokemonsNetworkDataProvider _networkDataProvider;

  @override
  Future<PokemonPreview> fetchPokemon(int id) async => _networkDataProvider.fetchPokemon(id);

  @override
  Stream<PokemonPreview> fetchPokemonGroup(int count) async* {
    for (var i = 0; i < count; i++) {
      yield await _networkDataProvider.fetchPokemon(i + 1);
    }
  }
}
