part of 'games_cubit.dart';

abstract class GamesState extends Equatable {
  const GamesState();
}

class GamesInitialState extends GamesState {
  @override
  List<Object?> get props => [];
}

class GamesLoadingState extends GamesState {
  @override
  List<Object?> get props => [];
}

class GamesLoadedState extends GamesState {
  const GamesLoadedState();
  @override
  List<Object?> get props => [];
}

class GamesErrorState extends GamesState {
  final String errorMessage;

  const GamesErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
