import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:pokemon/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:pokemon/src/feature/settings/model/app_settings.dart';

/// {@template settings_scope}
/// SettingsScope widget.
/// {@endtemplate}
class SettingsScope extends StatefulWidget {
  /// {@macro settings_scope}
  const SettingsScope({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  static void switchThemeModel(BuildContext context) {
    final controller = of(context, listen: false);
    final setting = controller.state.appSettings;

    if (setting == null) return;
    controller.add(AppSettingsEvent.updateAppSettings(
        appSettings: setting.copyWith(appTheme: setting.appTheme?.switchTheme())));
  }

  /// Get the [AppSettingsBloc] instance.
  static AppSettingsBloc of(
    BuildContext context, {
    bool listen = true,
  }) {
    final settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedSettings>()
        : context.getInheritedWidgetOfExactType<_InheritedSettings>();
    return settingsScope!.state._appSettingsBloc;
  }

  /// Get the [AppSettings] instance.
  static AppSettings settingsOf(
    BuildContext context, {
    bool listen = true,
  }) {
    final settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedSettings>()
        : context.getInheritedWidgetOfExactType<_InheritedSettings>();
    return settingsScope!.settings ?? const AppSettings();
  }

  static ThemeMode themeModeOf(
    BuildContext context, {
    bool listen = true,
  }) =>
      settingsOf(context, listen: listen).appTheme?.themeMode ?? ThemeMode.system;

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

/// State for widget SettingsScope.
class _SettingsScopeState extends State<SettingsScope> {
  late final AppSettingsBloc _appSettingsBloc;

  @override
  void initState() {
    _appSettingsBloc = DependenciesScope.of(context).appSettingsBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AppSettingsBloc, AppSettingsState>(
        bloc: _appSettingsBloc,
        builder: (context, state) => _InheritedSettings(
          settings: state.appSettings,
          state: this,
          child: widget.child,
        ),
      );
}

/// {@template inherited_settings}
/// _InheritedSettings widget.
/// {@endtemplate}
class _InheritedSettings extends InheritedWidget {
  /// {@macro inherited_settings}
  const _InheritedSettings({
    required super.child,
    required this.state,
    required this.settings,
    super.key, // ignore: unused_element
  });

  /// _SettingsScopeState instance.
  final _SettingsScopeState state;
  final AppSettings? settings;

  @override
  bool updateShouldNotify(covariant _InheritedSettings oldWidget) => settings != oldWidget.settings;
}
