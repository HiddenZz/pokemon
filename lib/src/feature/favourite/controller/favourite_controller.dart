import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/src/feature/favourite/data/favourite_repository.dart';
import 'package:pokemon/src/feature/pokemons/model/pokemon_preview.dart';

final class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  FavouriteBloc({
    required FavouriteRepository favouriteRepository,
    FavouriteState? initialState,
  })  : _favouriteRepository = favouriteRepository,
        super(initialState ?? const FavouriteState.idle()) {
    on<FavouriteEvent>(
      (event, emit) => switch (event) {
        _AddGroupEvent() => _add(event, emit),
        _RemoveGroupEvent() => _remove(event, emit),
      },
    );
  }

  final FavouriteRepository _favouriteRepository;

  Future<void> _add(
    _AddGroupEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    try {
      emit(FavouriteState.loading(favourites: state.favourites));
      final favourites = await _favouriteRepository.add(event.id);
      emit(FavouriteState.idle(favourites: favourites));
    } catch (error) {
      emit(FavouriteState.error(error: error, favourites: state.favourites));
    }
  }

  Future<void> _remove(
    _RemoveGroupEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    try {
      emit(FavouriteState.loading(favourites: state.favourites));
      final favourites = await _favouriteRepository.remove(event.id);
      emit(FavouriteState.idle(favourites: favourites));
    } catch (error) {
      emit(FavouriteState.error(error: error, favourites: state.favourites));
    }
  }
}

sealed class FavouriteState {
  const FavouriteState({this.favourites = const {}});

  final Set<int> favourites;

  const factory FavouriteState.idle({Set<int> favourites}) = _IdlePokemonPreviewState;

  const factory FavouriteState.loading({Set<int> favourites}) = _LoadingPokemonPreviewState;

  const factory FavouriteState.error({required Object error, Set<int> favourites}) =
      _ErrorPokemonPreviewState;
}

final class _IdlePokemonPreviewState extends FavouriteState {
  const _IdlePokemonPreviewState({super.favourites});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _IdlePokemonPreviewState && other.favourites == favourites;
  }

  @override
  int get hashCode => favourites.hashCode;

  @override
  String toString() => '_IdlePokemonPreviewState.idle(PokemonPreview: $favourites)';
}

final class _LoadingPokemonPreviewState extends FavouriteState {
  const _LoadingPokemonPreviewState({super.favourites});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _LoadingPokemonPreviewState && other.favourites == favourites;
  }

  @override
  int get hashCode => favourites.hashCode;

  @override
  String toString() => '_LoadingPokemonPreviewState.loading(PokemonPreview: $favourites)';
}

final class _ErrorPokemonPreviewState extends FavouriteState {
  const _ErrorPokemonPreviewState({required this.error, super.favourites});

  /// The error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ErrorPokemonPreviewState &&
        other.favourites == favourites &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(favourites, error);

  @override
  String toString() =>
      '_ErrorPokemonPreviewState.error(PokemonPreview: $favourites, error: $error)';
}

/// Events for the [FavouriteBloc].
sealed class FavouriteEvent {
  const FavouriteEvent();

  const factory FavouriteEvent.add({
    required int id,
  }) = _AddGroupEvent;

  const factory FavouriteEvent.remove({
    required int id,
  }) = _RemoveGroupEvent;
}

final class _AddGroupEvent extends FavouriteEvent {
  const _AddGroupEvent({required this.id});

  /// The theme to update.
  final int id;

  @override
  String toString() => 'FavouriteEvent.add(PokemonPreview: $PokemonPreview)';
}

final class _RemoveGroupEvent extends FavouriteEvent {
  const _RemoveGroupEvent({required this.id});

  /// The theme to update.
  final int id;

  @override
  String toString() => 'FavouriteEvent.remove(PokemonPreview: $PokemonPreview)';
}
