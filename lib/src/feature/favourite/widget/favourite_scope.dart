import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/src/feature/favourite/controller/favourite_controller.dart';
import 'package:pokemon/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:pokemon/src/feature/pokemons/widget/pokemon_scope.dart';

/// {@template favourite_scope}
/// FavouriteScope widget.
/// {@endtemplate}
class FavouriteScope extends StatefulWidget {
  /// {@macro favourite_scope}
  const FavouriteScope({
    required this.child,
    super.key, // ignore: unused_element
  });

  /// The widget below this widget in the tree.
  final Widget child;

  static bool isFavouritBadOf(BuildContext context, {required PokemonId id, bool listen = true}) =>
      _FavouriteInheritedBad.isFavourite(context, id, listen: listen);

  static bool isFavouritOf(BuildContext context, {required PokemonId id, bool listen = true}) =>
      _FavouriteInherited.isFavourite(context, id, listen: listen);

  static void add(BuildContext context, {required PokemonId id}) =>
      DependenciesScope.of(context).favouriteBloc.add(FavouriteEvent.add(id: id));

  static void remove(BuildContext context, {required PokemonId id}) =>
      DependenciesScope.of(context).favouriteBloc.add(FavouriteEvent.remove(id: id));

  static void toggle(BuildContext context, {required PokemonId id}) {
    final isFavourite = isFavouritOf(context, id: id, listen: false);
    if (isFavourite) {
      remove(context, id: id);
      return;
    }
    add(context, id: id);
  }

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static FavouriteScopeController? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_FavouriteScopeState>();

  @override
  State<FavouriteScope> createState() => _FavouriteScopeState();
}

/// State for widget FavouriteScope.
class _FavouriteScopeState extends State<FavouriteScope> with FavouriteScopeController {
  late final FavouriteBloc controller;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initialization of the stent
    controller = DependenciesScope.of(context).favouriteBloc;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<FavouriteBloc, FavouriteState>(
        bloc: controller,
        builder: (context, state) => _FavouriteInherited(
          child: _FavouriteInheritedBad(
            child: widget.child,
            favourites: state.favourites,
          ),
          favourites: state.favourites,
        ),
      );
}

/// Controller for widget FavouriteScope
mixin FavouriteScopeController {
  abstract final FavouriteBloc controller;
}

/// {@template favourite_scope}
/// _FavouriteInherited widget.
/// {@endtemplate}
class _FavouriteInherited extends InheritedModel<PokemonId> {
  /// {@macro favourite_scope}
  const _FavouriteInherited({
    required super.child,
    required this.favourites,
    super.key, // ignore: unused_element
  });

  final Set<PokemonId> favourites;

  @override
  bool updateShouldNotify(covariant _FavouriteInherited oldWidget) =>
      !setEquals(favourites, oldWidget.favourites);

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  /// e.g. `_FavouriteInherited.maybeOf(context)`.
  static _FavouriteInherited? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_FavouriteInherited>()
      : context.getInheritedWidgetOfExactType<_FavouriteInherited>();

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a _FavouriteInherited of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  /// e.g. `_FavouriteInherited.of(context)`
  // ignore: unused_element
  static _FavouriteInherited of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  static bool isFavourite(
    BuildContext context,
    PokemonId id, {
    bool listen = true,
  }) =>
      (listen
              ? InheritedModel.inheritFrom<_FavouriteInherited>(
                  context,
                  aspect: id,
                )
              : maybeOf(
                  context,
                  listen: false,
                ))
          ?.favourites
          .contains(id) ??
      false;

  @override
  bool updateShouldNotifyDependent(
      covariant _FavouriteInherited oldWidget, Set<PokemonId> aspects) {
    for (final id in aspects) {
      if (favourites.contains(id) != oldWidget.favourites.contains(id)) {
        return true;
      }
    }
    return false;
  }
}

class _FavouriteInheritedBad extends InheritedWidget {
  /// {@macro favourite_scope}
  const _FavouriteInheritedBad({
    required super.child,
    required this.favourites,
    super.key, // ignore: unused_element
  });

  final Set<PokemonId> favourites;

  @override
  bool updateShouldNotify(covariant _FavouriteInheritedBad oldWidget) =>
      !setEquals(favourites, oldWidget.favourites);

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  /// e.g. `_FavouriteInherited.maybeOf(context)`.
  static _FavouriteInheritedBad? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_FavouriteInheritedBad>()
      : context.getInheritedWidgetOfExactType<_FavouriteInheritedBad>();

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a _FavouriteInherited of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  /// e.g. `_FavouriteInherited.of(context)`
  // ignore: unused_element
  static _FavouriteInheritedBad of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  static bool isFavourite(
    BuildContext context,
    PokemonId id, {
    bool listen = true,
  }) =>
      maybeOf(
        context,
        listen: listen,
      )?.favourites.contains(id) ??
      false;
}
