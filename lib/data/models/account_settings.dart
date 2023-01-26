import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const defaultCurrency = 'USD';
const defaultLocale = Locale('en');
const defaultThemeMode = ThemeMode.dark;

class AccountSettings extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final String currency;

  const AccountSettings({
    this.themeMode = defaultThemeMode,
    this.locale = defaultLocale,
    this.currency = defaultCurrency,
  });

  @override
  List<Object?> get props => [
        themeMode,
        locale,
        currency,
      ];

  AccountSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    String? currency,
  }) {
    return AccountSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      currency: currency ?? this.currency,
    );
  }
}
