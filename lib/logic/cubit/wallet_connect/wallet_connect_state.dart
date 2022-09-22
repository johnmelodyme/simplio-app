part of 'wallet_connect_cubit.dart';

class WalletConnectState extends Equatable {
  final Map<String, WalletConnectPeer> sessions;
  final Map<String, WalletConnectRequest> requests;

  const WalletConnectState({
    required this.sessions,
    required this.requests,
  });

  bool get isModal => requests.isNotEmpty;
  bool get isConnected => sessions.isNotEmpty;

  @override
  List<Object?> get props => [isModal, requests, sessions, isConnected];

  WalletConnectState addRequest(WalletConnectRequest request) {
    return WalletConnectState(
        sessions: sessions,
        requests: Map<String, WalletConnectRequest>.from(requests)
          ..update(
            request.topicId,
            (_) => request,
            ifAbsent: () => request,
          ));
  }

  WalletConnectState removeRequest(WalletConnectRequest request) {
    return WalletConnectState(
      sessions: sessions,
      requests: Map<String, WalletConnectRequest>.from(requests)
        ..remove(request.topicId),
    );
  }

  WalletConnectState removeRequests(String topicId) {
    final entries = Map<String, WalletConnectRequest>.from(requests)
        .entries
        .where((e) => e.key != topicId);

    return WalletConnectState(
      sessions: sessions,
      requests: Map.fromEntries(entries),
    );
  }

  WalletConnectState copyWith({
    Map<String, WalletConnectPeer>? sessions,
    Map<String, WalletConnectRequest>? requests,
  }) {
    return WalletConnectState(
      sessions: sessions ?? this.sessions,
      requests: requests ?? this.requests,
    );
  }
}
