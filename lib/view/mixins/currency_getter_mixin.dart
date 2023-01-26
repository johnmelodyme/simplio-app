import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/models/account_settings.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';

mixin CurrencyGetter on Widget {
  String getCurrency(BuildContext context) {
    final s = context.read<AccountCubit>().state;
    if (s is! AccountProvided) return defaultCurrency;

    return s.account.settings.currency;
  }
}
