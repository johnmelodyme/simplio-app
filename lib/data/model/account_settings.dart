import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'account_settings.g.dart';

const defaultLocale = Locale('en');
const defaultThemeMode = ThemeMode.dark;

class AccountSettings extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const AccountSettings({
    required this.themeMode,
    required this.locale,
  });

  const AccountSettings.builder({
    ThemeMode? themeMode,
    Locale? locale,
  }) : this(
          themeMode: themeMode ?? defaultThemeMode,
          locale: locale ?? defaultLocale,
        );

  @override
  List<Object?> get props => [
        themeMode,
        locale,
      ];

  AccountSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AccountSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

@HiveType(typeId: 2)
class AccountSettingsLocal {
  @HiveField(0)
  final int themeMode;
  @HiveField(1)
  final String languageCode;

  const AccountSettingsLocal({
    required this.themeMode,
    required this.languageCode,
  });
}
