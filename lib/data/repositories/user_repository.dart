import 'package:simplio_app/data/http/apis/account_api.dart';
import 'package:simplio_app/data/http/services/account_service.dart';

// TODO - This should belong to a account repository or should have its own domain like sync repository.
class UserRepository {
  final AccountApi _accountApi;

  UserRepository._(
    this._accountApi,
  );

  UserRepository({
    required AccountApi accountApi,
  }) : this._(
          accountApi,
        );

  Future<AccountProfileResponse> getAccountProfile() {
    return _accountApi.getAccountProfile();
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
    AccountProfileResponse userProfile,
  ) {
    return _accountApi.updateUserProfile(userProfile);
  }
}
