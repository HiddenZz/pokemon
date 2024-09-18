import 'package:pokemon/src/core/rest_client/rest_client.dart';
import 'package:pokemon/src/feature/pokemons/model/pokemon_preview.dart';

/// Interface for network data provider
abstract interface class IPokemonsNetworkDataProvider {
  /// Fetch pokemons
  Future<PokemonPreview> fetchPokemon(int id);
}

final class PokemonsNetworkDataProviderImpl implements IPokemonsNetworkDataProvider {
  PokemonsNetworkDataProviderImpl({required RestClient client}) : _client = client;

  final RestClient _client;

  @override
  Future<PokemonPreview> fetchPokemon(int id) async {
    final response = await _client.get('pokemon/$id');

    if (response == null) throw Exception('Failed to load pokemons');
    return PokemonPreview.fromJson(response);
  }
}
