import 'package:pokemon/src/feature/pokemons/widget/pokemon_scope.dart';

abstract interface class FavouriteRepository {
  Future<Set<PokemonId>> add(PokemonId id);
  Future<Set<PokemonId>> remove(PokemonId id);
}

final class FavouriteRepositoryImpl implements FavouriteRepository {
  FavouriteRepositoryImpl();

  Set<PokemonId> _favourites = {};

  @override
  Future<Set<PokemonId>> add(PokemonId id) =>
      Future.delayed(Duration(milliseconds: 200), () => Set<PokemonId>.of(_favourites..add(id)));

  @override
  Future<Set<PokemonId>> remove(PokemonId id) =>
      Future.delayed(Duration(milliseconds: 200), () => Set<PokemonId>.of(_favourites..remove(id)));
}
