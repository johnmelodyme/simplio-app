import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './tap_bar_state.dart';

class TapBarCubit extends Cubit<TapBarState> {
  TapBarCubit() : super(const TapBarState.init());

  void setVisibility({
    bool? isVisible = false,
    Key? activeItem,
  }) {
    emit(state.copyWith(
      isDisplayed: isVisible,
      selectedItem: activeItem,
    ));
  }
}
