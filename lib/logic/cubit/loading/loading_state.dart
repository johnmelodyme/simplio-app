part of 'loading_cubit.dart';

class LoadingState extends Equatable {
  final bool displaySplashScreen;

  const LoadingState._({required this.displaySplashScreen});

  const LoadingState.initial() : this._(displaySplashScreen: true);

  const LoadingState.value({required bool displaySplashScreen})
      : this._(displaySplashScreen: displaySplashScreen);

  @override
  List<Object?> get props => [displaySplashScreen];

  LoadingState copyWith({bool? displaySplashScreen}) {
    return LoadingState.value(
        displaySplashScreen: displaySplashScreen ?? this.displaySplashScreen);
  }
}
