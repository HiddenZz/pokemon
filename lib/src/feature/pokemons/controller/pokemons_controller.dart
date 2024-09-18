import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/src/feature/pokemons/data/pokemos_repository.dart';
import 'package:pokemon/src/feature/pokemons/model/pokemon_preview.dart';

final class PokemonPreviewBloc extends Bloc<PokemonPreviewEvent, PokemosPreviewState> {
  PokemonPreviewBloc({
    required PokemonsRepository pokemonPreviewRepository,
    required PokemosPreviewState initialState,
  })  : _pokemonPreviewRepository = pokemonPreviewRepository,
        super(initialState) {
    on<PokemonPreviewEvent>(
      (event, emit) => switch (event) {
        final _FetchPokemonPreviewEvent e => _fetchPokemon(e, emit),
        final _FetchPokemonPreviewGroupEvent e => _fetchPokemonGroup(e, emit),
      },
    );
  }

  final PokemonsRepository _pokemonPreviewRepository;

  Future<void> _fetchPokemon(
    _FetchPokemonPreviewEvent event,
    Emitter<PokemosPreviewState> emit,
  ) async {
    try {
      emit(_LoadingPokemonPreviewState(pokemonPreview: state.pokemonPreview));
      final pokemon = await _pokemonPreviewRepository.fetchPokemon(event.id);
      emit(_IdlePokemonPreviewState(pokemonPreview: pokemon));
    } catch (error) {
      emit(_ErrorPokemonPreviewState(error: error));
    }
  }

  Future<void> _fetchPokemonGroup(
    _FetchPokemonPreviewGroupEvent event,
    Emitter<PokemosPreviewState> emit,
  ) async {
    try {
      emit(_LoadingPokemonPreviewState(pokemonPreview: state.pokemonPreview));
      final stream = _pokemonPreviewRepository.fetchPokemonGroup(event.count).listen((pokemon) {
        emit(_IdlePokemonPreviewState(pokemonPreview: pokemon));
      });
      await stream.asFuture();
    } catch (error) {
      emit(_ErrorPokemonPreviewState(error: error));
    }
  }
}

sealed class PokemosPreviewState {
  const PokemosPreviewState({this.pokemonPreview});

  final PokemonPreview? pokemonPreview;

  const factory PokemosPreviewState.idle({PokemonPreview? pokemonPreview}) =
      _IdlePokemonPreviewState;

  const factory PokemosPreviewState.loading({PokemonPreview? pokemonPreview}) =
      _LoadingPokemonPreviewState;

  const factory PokemosPreviewState.error({
    required Object error,
    PokemonPreview? pokemonPreview,
  }) = _ErrorPokemonPreviewState;
}

final class _IdlePokemonPreviewState extends PokemosPreviewState {
  const _IdlePokemonPreviewState({super.pokemonPreview});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _IdlePokemonPreviewState && other.pokemonPreview == pokemonPreview;
  }

  @override
  int get hashCode => pokemonPreview.hashCode;

  @override
  String toString() => '_IdlePokemonPreviewState.idle(PokemonPreview: $pokemonPreview)';
}

final class _LoadingPokemonPreviewState extends PokemosPreviewState {
  const _LoadingPokemonPreviewState({super.pokemonPreview});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _LoadingPokemonPreviewState && other.pokemonPreview == pokemonPreview;
  }

  @override
  int get hashCode => pokemonPreview.hashCode;

  @override
  String toString() => '_LoadingPokemonPreviewState.loading(PokemonPreview: $pokemonPreview)';
}

final class _ErrorPokemonPreviewState extends PokemosPreviewState {
  const _ErrorPokemonPreviewState({required this.error, super.pokemonPreview});

  /// The error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ErrorPokemonPreviewState &&
        other.pokemonPreview == pokemonPreview &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(pokemonPreview, error);

  @override
  String toString() =>
      '_ErrorPokemonPreviewState.error(PokemonPreview: $pokemonPreview, error: $error)';
}

/// Events for the [PokemonPreviewBloc].
sealed class PokemonPreviewEvent {
  const PokemonPreviewEvent();

  const factory PokemonPreviewEvent.fetch({
    required int id,
  }) = _FetchPokemonPreviewEvent;

  const factory PokemonPreviewEvent.fetchGroup({
    required int count,
  }) = _FetchPokemonPreviewGroupEvent;
}

final class _FetchPokemonPreviewGroupEvent extends PokemonPreviewEvent {
  const _FetchPokemonPreviewGroupEvent({required this.count});

  final int count;

  @override
  String toString() => 'PokemonPreviewEvent.fetch(PokemonPreview: $PokemonPreview)';
}

final class _FetchPokemonPreviewEvent extends PokemonPreviewEvent {
  const _FetchPokemonPreviewEvent({required this.id});

  final int id;

  @override
  String toString() => 'PokemonPreviewEvent.fetchGroup(PokemonPreview: $PokemonPreview)';
}
