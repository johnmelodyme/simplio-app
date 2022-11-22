import 'package:equatable/equatable.dart';

abstract class GameBlocEvent extends Equatable {
  const GameBlocEvent();
}

class LoadGamesEvent extends GameBlocEvent {
  final int page;

  const LoadGamesEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

class LoadMyGamesEvent extends GameBlocEvent {
  const LoadMyGamesEvent();

  @override
  List<Object?> get props => [];
}

class ReloadGamesEvent extends GameBlocEvent {
  const ReloadGamesEvent();

  @override
  List<Object?> get props => [];
}

class SearchGamesEvent extends GameBlocEvent {
  final String criteria;
  const SearchGamesEvent(this.criteria);

  @override
  List<Object?> get props => [criteria];
}

class LoadGameEvent extends GameBlocEvent {
  final String gameId;

  const LoadGameEvent({required this.gameId});

  @override
  List<Object?> get props => [];
}

class CheckIfGameIsAddedEvent extends GameBlocEvent {
  final int gameId;

  const CheckIfGameIsAddedEvent({required this.gameId});

  @override
  List<Object?> get props => [];
}

class AddGameToLibraryEvent extends GameBlocEvent {
  final int gameId;
  final bool reload;

  const AddGameToLibraryEvent({
    required this.gameId,
    this.reload = false,
  });

  @override
  List<Object?> get props => [];
}

class RemoveGameFromLibraryEvent extends GameBlocEvent {
  final int gameId;
  final bool reload;

  const RemoveGameFromLibraryEvent({
    required this.gameId,
    this.reload = false,
  });

  @override
  List<Object?> get props => [];
}
