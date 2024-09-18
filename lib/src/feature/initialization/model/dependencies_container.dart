import 'package:pokemon/src/core/rest_client/rest_client.dart';
import 'package:pokemon/src/feature/favourite/controller/favourite_controller.dart';
import 'package:pokemon/src/feature/initialization/logic/composition_root.dart';
import 'package:pokemon/src/feature/initialization/logic/error_tracking_manager.dart';
import 'package:pokemon/src/feature/pokemons/controller/pokemons_controller.dart';
import 'package:pokemon/src/feature/settings/bloc/app_settings_bloc.dart';

/// {@template dependencies_container}
/// Composed dependencies from the [CompositionRoot].
///
/// This class contains all the dependencies that are required for the application
/// to work.
///
/// {@macro composition_process}
/// {@endtemplate}
base class DependenciesContainer {
  /// {@macro dependencies_container}
  const DependenciesContainer({
    required this.appSettingsBloc,
    required this.errorTrackingManager,
    required this.restClient,
    required this.pokemonsPreviewBloc,
    required this.favouriteBloc,
  });

  /// [AppSettingsBloc] instance, used to manage theme and locale.
  final AppSettingsBloc appSettingsBloc;

  /// [ErrorTrackingManager] instance, used to report errors.
  final ErrorTrackingManager errorTrackingManager;

  /// [RestClient] instance, used to make HTTP requests.
  final RestClient restClient;

  ///[PokemonPreviewBloc] instance, used to manage pokemons preview.
  final PokemonPreviewBloc pokemonsPreviewBloc;

  /// [FavouriteBloc] instance, used to manage favourite pokemons.
  final FavouriteBloc favouriteBloc;
}

/// {@template testing_dependencies_container}
/// A special version of [DependenciesContainer] that is used in tests.
///
/// In order to use [DependenciesContainer] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
/// {@endtemplate}
base class TestDependenciesContainer implements DependenciesContainer {
  @override
  Object? noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} dependency, but '
      'it was not provided. Please provide the dependency in the test. '
      'You can do it by extending this class and providing the dependency.',
    );
  }
}
