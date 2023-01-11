import 'dart:convert';

enum HttpErrorCodes {
  buyChangedRate(code: 'RATES_CHANGED'),
  authMissingCredentials(code: 'AUTH_CREDENTIALS_MISSING'),
  authMissingEmail(code: 'AUTH_EMAIL_MISSING'),
  authInvalidEmail(code: 'AUTH_EMAIL_INVALID'),
  authMissingPassword(code: 'AUTH_PASSWORD_MISSING'),
  authInvalidPassword(code: 'AUTH_PASSWORD_INVALID'),
  authInvalidOldPassword(code: 'AUTH_PASSWORD_OLD_INVALID'),
  authInvalidNewPassword(code: 'AUTH_PASSWORD_NEW_INVALID'),
  authInvalidChangedPassword(code: 'AUTH_PASSWORD_CHANGE_INVALID'),
  authChangingPasswordFailed(code: 'AUTH_PASSWORD_CHANGE_FAILED'),
  authPasswordResetWithFailure(code: 'AUTH_PASSWORD_RESET_UNSUCCESSFUL'),
  authResetPasswordFailed(code: 'AUTH_PASSWORD_RESET_FAILED'),
  authChangingPasswordDuplicated(code: 'AUTH_PASSWORD_CHANGE_FAILED_SAME'),
  authMissingRefreshToken(code: 'AUTH_REFRESH_TOKEN_MISSING'),
  authRefreshingTokenFailed(code: 'AUTH_REFRESH_TOKEN_FAILED'),
  authRefreshTokenCorrupted(code: 'AUTH_REFRESH_TOKEN_WASNT_GET'),
  authMissingBearerToken(code: 'AUTH_BEARER_TOKEN_MISSING'),
  authSignUpFailed(code: 'AUTH_USER_REGISTRATION_FAILED'),
  authAccountNotFound(code: 'AUTH_USER_NOT_FOUND'),
  authUpdatingAccountFailed(code: 'AUTH_USER_UPDATE_FAILED'),
  authAccountForbidden(code: 'AUTH_USER_FORBIDDEN'),
  blockchainBroadcastFailed(code: 'BLC_CHN_BROADCAST_UNSUCCESSFUL'),
  blockchainBalanceFailed(code: 'BLC_CHN_BALANCE_UNSUCCESSFUL'),
  blockchainTokenBalanceFailed(code: 'BLC_CHN_BALANCE_TOKEN_UNSUCCESSFUL'),
  blockchainHistoryFailed(code: 'BLC_CHN_HISTORY_UNSUCCESSFUL'),
  blockchainTokenHistoryFailed(code: 'BLC_CHN_HISTORY_TOKEN_UNSUCCESSFUL'),
  blockchainUtilsFailed(code: 'BLC_CHN_UTILS_UNSUCCESSFUL'),
  buyPairsFailed(code: 'DBT_CRD_PAIRS_UNSUCCESSFUL'),
  buyHistoryFailed(code: 'DBT_CRD_HISTORY_UNSUCCESSFUL'),
  buyInitializeOrderFailed(code: 'DBT_CRD_INITIALIZE_ORDER_UNSUCCESSFUL'),
  buyCancelingOrderFailed(code: 'DBT_CRD_CANCEL_ORDER_UNSUCCESSFUL'),
  buyConvertingValueFailed(code: 'DBT_CRD_CONVERT_UNSUCCESSFUL'),
  generalError(code: 'GEN_UNKNOWN_ERROR'),
  generalInvalidParams(code: 'GEN_INVALID_PARAMETERS'),
  entityNotFound(code: 'ENTITY_NOT_FOUND'),
  marketplaceLoadingGamesFailed(code: 'MRKPLC_GAME_LIST_UNSUCCESSFUL'),
  marketplaceGameDetailFailed(code: 'MRKPLC_GAME_DETAIL_UNSUCCESSFUL'),
  marketplaceSearchingGameFailed(code: 'MRKPLC_GAME_SEARCH_UNSUCCESSFUL'),
  marketplaceLoadingAssetFailed(code: 'MRKPLC_ASSET_LIST_UNSUCCESSFUL'),
  marketplaceSearchingAssetFailed(code: 'MRKPLC_ASSET_SEARCH_UNSUCCESSFUL'),
  statsLoadingAssetFailed(code: 'MRK_STS_ASSETS_STATS_UNSUCCESSFUL'),
  kycMissingActionKey(code: 'SUM_SUB_ACTION_KEY_MISSING'),
  swapSingleSwapFailed(code: 'SWAP_SINGLE_SWAP_UNSUCCESSFUL'),
  swapLoadingRoutesFailed(code: 'SWAP_SWAP_ROUTES_FAILED'),
  swapLoadingReportsFailed(code: 'SWAP_GET_REPORTS_FAILED'),
  swapConvertingFailed(code: 'SWAP_GET_SWAP_PARAMS'),
  sendFailed(code: 'TRANS_SENT_UNSUCCESSFUL'),
  unknown();

  final String code;

  const HttpErrorCodes({this.code = ''});
}

abstract class HttpError {
  final HttpErrorCodes code;
  final String message;
  final Map<String, dynamic> detail;

  const HttpError({
    required this.code,
    required this.message,
    required this.detail,
  });
}

class HttpErrorBody {
  const HttpErrorBody({
    this.code = HttpErrorCodes.unknown,
    this.message = '',
    this.detail = const {},
  });

  final HttpErrorCodes code;
  final String message;
  final Map<String, dynamic> detail;
}

class HttpErrorBodyConvertor {
  static HttpErrorBody fromObject(Object? object) {
    if (object is! String) return const HttpErrorBody();

    final Map<String, dynamic> map = json.decode(object);
    return fromMap(map);
  }

  static HttpErrorBody fromMap(Map<String, dynamic> map) {
    return HttpErrorBody(
      code: HttpErrorCodes.values.firstWhere(
          (e) => e.code == (map['ErrorCode'] is String ? map['ErrorCode'] : ''),
          orElse: () => HttpErrorCodes.unknown),
      message: map['ErrorMessage'] is String ? map['ErrorMessage'] : '',
      detail: map['ErrorDetail'] is Map ? map['detail'] : const {},
    );
  }
}
