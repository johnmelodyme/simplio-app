import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigators_state.dart';

class NavigatorsCubit extends Cubit<NavigatorsState> {
  NavigatorsCubit() : super(const NavigatorsState.init());

  void setVisibility({
    bool? appBarVisible = false,
    bool? tabBarVisible = false,
    Key? activeItem,
  }) {
    emit(state.copyWith(
      appBarDisplayed: appBarVisible,
      tabBarDisplayed: tabBarVisible,
      selectedItem: activeItem,
    ));
  }
}
