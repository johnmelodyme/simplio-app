import 'package:simplio_app/data/http/services/account_service.dart';

class UserRepository {
  final AccountService _accountService;

  UserRepository._(
    this._accountService,
  );

  UserRepository({
    required AccountService accountService,
  }) : this._(
          accountService,
        );

  Future<AccountProfileResponse> getAccountProfile() async {
    final res = await _accountService.profile();

    final body = res.body;
    if (res.isSuccessful && body != null) return body;

    throw Exception("Could not fetch account profile: ${res.error.toString()}");
  }

  Future<bool> gameIsAdded(int gameId) async {
    final userProfile = await getAccountProfile();
    final isAdded = userProfile.gameLibrary?.contains(gameId) == true;
    return isAdded;
  }

  Future<bool> addGameToLibrary(int gameId) async {
    final userProfile = await getAccountProfile();
    userProfile.gameLibrary ??= [];
    userProfile.gameLibrary?.add(gameId);

    final userProfileUpdated = await updateUserProfile(userProfile);
    final isAdded = userProfileUpdated.gameLibrary?.contains(gameId) == true;

    return isAdded;
  }

  Future<bool> removeGameFromLibrary(int gameId) async {
    final userProfile = await getAccountProfile();
    userProfile.gameLibrary?.removeWhere((id) => id == gameId);

    final userProfileUpdated = await updateUserProfile(userProfile);
    final isAdded = userProfileUpdated.gameLibrary?.contains(gameId) == true;

    return isAdded;
  }

  Future<AccountProfileResponse> updateUserProfile(
      AccountProfileResponse userProfile) async {
    final res = await _accountService.updateProfile(userProfile);

    final body = res.body;
    if (res.isSuccessful && body != null) return body;

    throw Exception("Could not fetch account profile: ${res.error.toString()}");
  }
}
