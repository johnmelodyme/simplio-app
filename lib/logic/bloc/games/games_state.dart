part of 'games_bloc.dart';

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

class MyGamesLoadedState extends GamesState {
  const MyGamesLoadedState(this.games);

  final List<Game> games;

  @override
  List<Object?> get props => [games];
}

class GamesErrorState extends GamesState {
  final String errorMessage;

  const GamesErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class GameDetailLoadedState extends GamesState {
  const GameDetailLoadedState({
    required this.gameDetail,
  });

  final GameDetail gameDetail;

  @override
  List<Object?> get props => [gameDetail];
}

class GameDetailIsAddedState extends GamesState {
  const GameDetailIsAddedState({
    required this.isAdded,
    this.wasUpdated = false,
  });

  final bool? isAdded;
  final bool wasUpdated;

  @override
  List<Object?> get props => [isAdded, wasUpdated];
}
