import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pokemon/src/feature/favourite/widget/favourite_button.dart';
import 'package:pokemon/src/feature/pokemons/model/pokemon_preview.dart';
import 'package:pokemon/src/feature/pokemons/widget/pokemon_scope.dart';
import 'package:pokemon/src/feature/settings/widget/settings_scope.dart';

/// {@template pokemos_screen}
/// PokemosScreen widget.
/// {@endtemplate}
class PokemosScreen extends StatefulWidget {
  /// {@macro pokemos_screen}
  const PokemosScreen({
    super.key, // ignore: unused_element
  });

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  @internal
  static _PokemosScreenState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_PokemosScreenState>();

  @override
  State<PokemosScreen> createState() => _PokemosScreenState();
}

/// State for widget PokemosScreen.
class _PokemosScreenState extends State<PokemosScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            // --- App Bar --- //
            SliverAppBar(
              pinned: MediaQuery.sizeOf(context).height > 600,
              title: const _AppBar(),
              leading: const SizedBox.shrink(),
              actions: <Widget>[
                IconButton(
                  icon: Icon(switch (SettingsScope.themeModeOf(context)) {
                    ThemeMode.dark => Icons.dark_mode,
                    _ => Icons.light_mode,
                  }),
                  onPressed: () => SettingsScope.switchThemeModel(context),
                ),
              ],
            ),

            // --- Scroll View --- //
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: const _PokemonsGrideView(),
            ),
          ],
        ),
      );
}

class _AppBar extends StatelessWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) =>
      Text('Pokemons Count ${PokemonScope.pokemonsOf(context).length}');
}

class _PokemonsGrideView extends StatelessWidget {
  const _PokemonsGrideView({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    final pokemons = PokemonScope.pokemonsOf(context);
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 256,
        childAspectRatio: 256 / 290,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        final pokemon = pokemons[index];
        return _PokemonGridTile(
          pokemon,
          key: ValueKey<int>(pokemon.id),
        );
      },
    );
  }
}

class _PokemonGridTile extends StatelessWidget {
  const _PokemonGridTile(
    this.pokemon, {
    super.key,
  });

  final PokemonPreview pokemon;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: <Widget>[
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Center(child: _PokemonCardImage(pokemon: pokemon)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Align(
                      alignment: const Alignment(0, -.5),
                      child: Column(
                        children: <Widget>[
                          Text(
                            pokemon.name ?? 'Unknown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 0.9,
                              letterSpacing: -0.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PokemonCardImage extends StatelessWidget {
  const _PokemonCardImage({
    required this.pokemon,
    super.key, // ignore: unused_element
  });

  final PokemonPreview pokemon;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Hero(
          tag: 'pokemon-${pokemon.id}-image',
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(pokemon.sprites.frontDefault ?? ''),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: Align(alignment: Alignment.topLeft, child: FavouriteButton(id: pokemon.id)),
          ),
        ),
      );
}
