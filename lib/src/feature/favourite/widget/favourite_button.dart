import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pokemon/src/feature/favourite/widget/favourite_scope.dart';
import 'package:pokemon/src/feature/pokemons/widget/pokemon_scope.dart';

/// {@template favourite_button}
/// FavouriteButton widget.
/// {@endtemplate}
class FavouriteButton extends StatefulWidget {
  /// {@macro favourite_button}
  const FavouriteButton({
    required this.id,
    super.key, // ignore: unused_element
  });
  final PokemonId id;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  @internal
  static _FavouriteButtonState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_FavouriteButtonState>();

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

/// State for widget FavouriteButton.
class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    log('FavouriteButton build ${widget.id}');
    return IconButton(
      onPressed: () => FavouriteScope.toggle(context, id: widget.id),
      icon: IconTheme(
        data: IconThemeData(
            size: 20,
            color:
                FavouriteScope.isFavouritOf(context, id: widget.id) ? Colors.orange : Colors.grey),
        child: Icon(
          Icons.favorite,
        ),
      ),
    );
  }
}
