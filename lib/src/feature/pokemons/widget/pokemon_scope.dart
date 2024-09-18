import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemon/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:pokemon/src/feature/pokemons/controller/pokemons_controller.dart';
import 'package:pokemon/src/feature/pokemons/model/pokemon_preview.dart';

/// {@template pokemon_scope}
/// PokemonScope widget.
/// {@endtemplate}
class PokemonScope extends StatefulWidget {
  /// {@macro pokemon_scope}
  const PokemonScope({
    required this.child,
    super.key, // ignore: unused_element
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static PokemonScopeController? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_PokemonScopeState>();

  static List<PokemonPreview> pokemonsOf(BuildContext context, {bool listen = true}) =>
      _PokemonInherited.of(context, listen: true).list;

  static void fetchPokemonGroup(BuildContext context, int count) =>
      maybeOf(context)?.controller.add(PokemonPreviewEvent.fetchGroup(count: count));

  @override
  State<PokemonScope> createState() => _PokemonScopeState();
}

typedef PokemonId = int;

/// State for widget PokemonScope.
class _PokemonScopeState extends State<PokemonScope> with PokemonScopeController {
  late final PokemonPreviewBloc controller;
  late List<PokemonPreview> _pokemons = <PokemonPreview>[];
  late Map<PokemonId, PokemonPreview> _pokemonsTab = <PokemonId, PokemonPreview>{};
  late final StreamSubscription<PokemonPreview?> _subscription;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
    controller = DependenciesScope.of(context).pokemonsPreviewBloc;
    controller.add(PokemonPreviewEvent.fetchGroup(count: 15));
    _subscription = controller.stream.map((state) => state.pokemonPreview).listen(_onDataChanged);
  }

  void _onDataChanged(PokemonPreview? pokemon) {
    if (pokemon == null) return;
    if (_pokemonsTab[pokemon.id] != null) return;
    _dataRebuild(pokemon);
  }

  void _dataRebuild(PokemonPreview pokemon) {
    setState(() {
      _pokemons = List<PokemonPreview>.of([..._pokemons, pokemon]);
      _pokemonsTab = <PokemonId, PokemonPreview>{
        for (final pokemon in _pokemons) pokemon.id: pokemon
      };
    });
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    _subscription.cancel();
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) =>
      _PokemonInherited(child: widget.child, list: _pokemons, tabs: _pokemonsTab);
}

/// Controller for widget PokemonScope
mixin PokemonScopeController {
  abstract final PokemonPreviewBloc controller;
}

/// {@template pokemon_scope}
/// _PokemonInherited widget.
/// {@endtemplate}
class _PokemonInherited extends InheritedWidget {
  /// {@macro pokemon_scope}
  const _PokemonInherited({
    required super.child,
    required this.list,
    required this.tabs,
    super.key, // ignore: unused_element
  });

  final List<PokemonPreview> list;
  final Map<PokemonId, PokemonPreview> tabs;

  @override
  bool updateShouldNotify(covariant _PokemonInherited oldWidget) =>
      !listEquals(list, oldWidget.list) && !mapEquals(tabs, oldWidget.tabs);

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  /// e.g. `_PokemonInherited.maybeOf(context)`.
  static _PokemonInherited? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_PokemonInherited>()
      : context.getInheritedWidgetOfExactType<_PokemonInherited>();

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a _PokemonInherited of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  /// e.g. `_PokemonInherited.of(context)`
  static _PokemonInherited of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();
}
