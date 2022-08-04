import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit._() : super(const LoadingState.initial());

  LoadingCubit.builder() : this._();

  void setSplashScreen(bool displaySplashScreen) {
    emit(state.copyWith(displaySplashScreen: displaySplashScreen));
  }
}
