import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/model/wallet_connect_session.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:wallet_connect/wallet_connect.dart';

class WalletConnectRepository {
  static const WalletConnectPeer sioPeer = WalletConnectPeer(
    name: 'Simplio',
    url: "https://simplio.io",
    icons: ["https://simplio.io/images/icons/_logo_blue_300x300.png"],
    description:
        'Multichain mobile app that lets you instantly play Web3 games',
  );

  final WalletConnectSessionDb _walletConnectSessionDb;

  /// Active sessions hold 'topicId' as their key and [WCClient] as value
  final Map<String, WCClient> _sessions = {};
  final _eventController = StreamController<WalletConnectEvent>();

  WalletConnectRepository._(this._walletConnectSessionDb);

  WalletConnectRepository({
    required WalletConnectSessionDb walletConnectSessionDb,
  }) : this._(walletConnectSessionDb);

  Stream<WalletConnectEvent> get events {
    return _eventController.stream.asBroadcastStream();
  }

  Map<String, WalletConnectPeer> get sessions => _sessions.values
      .where((s) => s.isConnected)
      .where((s) => s.session != null)
      .map((s) => MapEntry(
          s.session?.topic ?? '',
          WalletConnectPeer(
            name: s.remotePeerMeta?.name ?? '',
            url: s.remotePeerMeta?.url ?? '',
            icons: s.remotePeerMeta?.icons ?? const [],
          )))
      .fold({}, (acc, curr) => acc..addEntries([curr]));

  Future<void> openSession(
    String accountWalletId, {
    required String uri,
  }) {
    final session = WCSession.from(uri);

    return _connect(
      accountWalletId,
      topicId: session.topic,
      onConnect: (client) {
        client.connectNewSession(
          session: session,
          peerMeta: WCPeerMeta(
            name: sioPeer.name,
            url: sioPeer.url,
            description: sioPeer.description,
          ),
        );
      },
    );
  }

  Future<void> _connect(
    String accountWalletId, {
    required String topicId,
    required void Function(WCClient client) onConnect,
  }) async {
    final client = WCClient(
      onFailure: _onFailure(topicId),
      onConnect: _onSessionOpened(topicId, accountWalletId),
      onDisconnect: _onSessionClosed(topicId, accountWalletId),
      onSessionRequest: _onSessionRequest(topicId, accountWalletId),
      onEthSign: _onSignMessage(topicId, accountWalletId),
      onEthSendTransaction: _onSendTransaction(topicId, accountWalletId),
      onEthSignTransaction: _onSignTransaction(topicId, accountWalletId),
    );

    try {
      _sessions.putIfAbsent(topicId, () => client);
      onConnect(client);
    } catch (e) {
      _sessions.remove(topicId);
      throw Exception("Could not open a session to '$topicId'");
    }
  }

  /// Load stored sessions relative to given accountWalletId
  /// and try to make an active session.
  Future<void> loadSessions(String accountWalletId) async {
    _sessions.clear();

    final sessions = _walletConnectSessionDb.getAll(accountWalletId);

    for (final s in sessions) {
      final Map<String, dynamic> sessionJson = jsonDecode(s.sessionDetail);
      final session = WCSessionStore.fromJson(sessionJson);

      await _connect(
        accountWalletId,
        topicId: session.session.topic,
        onConnect: (client) {
          client.connectFromSessionStore(session);
        },
      );
    }
  }

  void closeSession(String topicId) {
    final WCClient? client = _sessions[topicId];
    if (client != null) client.killSession();
  }

  Future<void> approveSessionRequest(
    WalletConnectSessionRequest request, {
    required String walletAddress,
    required int chainId,
  }) async {
    final WCClient? client = _sessions[request.topicId];

    if (client == null) {
      throw Exception("Client for '${request.topicId}' session does not exist");
    }

    chainId = client.chainId ?? chainId;

    try {
      client.approveSession(
        accounts: [walletAddress],
        chainId: chainId,
      );
    } catch (e) {
      throw Exception("Approving session has failed");
    }

    try {
      await _walletConnectSessionDb.save(WalletConnectSessionLocal(
        accountWalletId: request.accountWalletId,
        topicId: request.topicId,
        sessionDetail: jsonEncode(client.sessionStore),
      ));
    } catch (e) {
      throw Exception("Storing Wallet Connect Session has failed");
    }
  }

  void rejectSessionRequest(WalletConnectSessionRequest request) {
    final WCClient? client = _sessions[request.topicId];

    if (client == null) {
      throw Exception("Client for '${request.topicId}' session does not exist");
    }

    try {
      client.rejectSession();
    } catch (e) {
      throw Exception("Approving session has failed");
    }
  }

  void rejectRequest(WalletConnectRequest request) {
    final WCClient? client = _sessions[request.topicId];

    if (client == null) {
      throw Exception("Client for '${request.topicId}' session does not exist");
    }

    try {
      client.rejectRequest(id: request.requestId);
    } catch (e) {
      throw Exception("Approving session has failed");
    }
  }

  void approveDataRequest(WalletConnectDataRequest request) {
    final WCClient? client = _sessions[request.topicId];

    if (client == null) {
      throw Exception("Client for '${request.topicId}' session does not exist");
    }

    try {
      client.approveRequest(id: request.requestId, result: request.data);
    } catch (e) {
      throw Exception("Approving session has failed");
    }
  }

  VoidCallback _onSessionOpened(
    String topicId,
    String accountWalletId,
  ) {
    return () {
      _eventController.add(
        WalletConnectSessionOpened(
          topicId: topicId,
          accountWalletId: accountWalletId,
        ),
      );
    };
  }

  SocketClose _onSessionClosed(
    String topicId,
    String accountWalletId,
  ) {
    return (_, __) async {
      final WCClient? client = _sessions[topicId];

      if (client == null) {
        throw Exception("Client for '$topicId' session does not exist");
      }

      try {
        await _walletConnectSessionDb.remove(topicId);
      } catch (e) {
        throw Exception("Client for '$topicId' session does not exist");
      }

      _sessions.remove(topicId);

      _eventController.add(WalletConnectSessionClosed(
        topicId: topicId,
        accountWalletId: accountWalletId,
      ));
    };
  }

  Function(dynamic error) _onFailure(String topicId) {
    return (dynamic error) {
      debugPrint("WC Failure: ${error.toString()}");
    };
  }

  SessionRequest _onSessionRequest(String topicId, String accountWalletId) {
    return (int requestId, WCPeerMeta peer) {
      final WCClient? client = _sessions[topicId];

      if (client == null) {
        throw Exception("Client for '$topicId' session does not exist");
      }

      final chainId = client.chainId ?? AssetRepository.chainId(networkId: 60);

      _eventController.add(
        WalletConnectSessionRequest(
          topicId: topicId,
          accountWalletId: accountWalletId,
          requestId: requestId,
          peer: WalletConnectPeer(
            name: peer.name,
            url: peer.url,
            icons: peer.icons,
          ),

          /// Chain ID is not always present
          networkId: AssetRepository.networkId(chainId: chainId),
        ),
      );
    };
  }

  EthSign _onSignMessage(String topicId, String accountWalletId) {
    return (
      int requestId,
      WCEthereumSignMessage message,
    ) {
      switch (message.type) {
        case WCSignType.MESSAGE:
          _eventController.add(_makeSignatureRequest(
            topicId: topicId,
            accountWalletId: accountWalletId,
            requestId: requestId,
            type: SignRequestType.message,
            message: message,
          ));
          break;
        case WCSignType.PERSONAL_MESSAGE:
          _eventController.add(_makeSignatureRequest(
            topicId: topicId,
            accountWalletId: accountWalletId,
            requestId: requestId,
            type: SignRequestType.personalMessage,
            message: message,
          ));
          break;
        case WCSignType.TYPED_MESSAGE:
          _eventController.add(_makeSignatureRequest(
            topicId: topicId,
            accountWalletId: accountWalletId,
            requestId: requestId,
            type: SignRequestType.typedMessage,
            message: message,
          ));
          break;
        default:
          throw Exception('Request type ${message.type} not supported');
      }
    };
  }

  WalletConnectSignatureRequest _makeSignatureRequest({
    required String topicId,
    required String accountWalletId,
    required int requestId,
    required SignRequestType type,
    required WCEthereumSignMessage message,
  }) {
    final WCClient? client = _sessions[topicId];

    if (client == null) {
      throw Exception("Client for '$topicId' session does not exist");
    }

    final data = message.data;
    if (data == null) {
      throw Exception("Client for '$topicId' has empty data to sign");
    }

    final chainId = client.chainId ?? AssetRepository.chainId(networkId: 60);
    final networkId = AssetRepository.networkId(chainId: chainId);

    return WalletConnectSignatureRequest(
      topicId: topicId,
      accountWalletId: accountWalletId,
      requestId: requestId,
      peer: WalletConnectPeer(
        name: client.remotePeerMeta?.name ?? '',
        url: client.remotePeerMeta?.url ?? '',
        icons: client.remotePeerMeta?.icons ?? const [],
      ),
      networkId: networkId,
      type: type,
      data: data,
    );
  }

  EthTransaction _onSendTransaction(String topicId, String accountWalletId) {
    return (int requestId, WCEthereumTransaction transaction) {
      _eventController.add(_makeTransactionRequest(
        topicId: topicId,
        accountWalletId: accountWalletId,
        requestId: requestId,
        type: TransactionRequestType.send,
        transaction: transaction,
      ));
    };
  }

  EthTransaction _onSignTransaction(String topicId, String accountWalletId) {
    return (int requestId, WCEthereumTransaction transaction) {
      _eventController.add(_makeTransactionRequest(
        topicId: topicId,
        accountWalletId: accountWalletId,
        requestId: requestId,
        type: TransactionRequestType.sign,
        transaction: transaction,
      ));
    };
  }

  WalletConnectTransactionRequest _makeTransactionRequest({
    required String topicId,
    required String accountWalletId,
    required int requestId,
    required TransactionRequestType type,
    required WCEthereumTransaction transaction,
  }) {
    final WCClient? client = _sessions[topicId];

    if (client == null) {
      throw Exception("Client for '$topicId' session does not exist");
    }

    final amount = transaction.value;
    final nonce = transaction.nonce;
    final gasPrice = transaction.gasPrice;
    final gas = transaction.gas;
    final gasLimit = transaction.gasLimit;
    final chainId = client.chainId ?? AssetRepository.chainId(networkId: 60);
    final networkId = AssetRepository.networkId(chainId: chainId);
    final assetId = AssetRepository.assetId(networkId: networkId);

    return WalletConnectTransactionRequest(
      topicId: topicId,
      requestId: requestId,
      accountWalletId: accountWalletId,
      type: type,
      peer: WalletConnectPeer(
        name: client.remotePeerMeta?.name ?? '',
        url: client.remotePeerMeta?.url ?? '',
        icons: client.remotePeerMeta?.icons ?? const [],
      ),
      fromAddress: transaction.from,
      toAddress: transaction.to,
      amount: amount != null ? BigInt.parse(amount) : BigInt.zero,
      networkId: networkId,
      chainId: chainId,
      assetId: assetId,
      nonce: nonce != null ? BigInt.parse(nonce) : null,
      gasPrice: gasPrice != null ? BigInt.parse(gasPrice) : null,
      gas: gas != null ? BigInt.parse(gas) : null,
      gasLimit: gasLimit != null ? BigInt.parse(gasLimit) : null,
      data: transaction.data,
    );
  }
}

abstract class WalletConnectEvent {
  final String topicId;
  final String accountWalletId;

  const WalletConnectEvent({
    required this.topicId,
    required this.accountWalletId,
  });
}

class WalletConnectSessionOpened extends WalletConnectEvent {
  const WalletConnectSessionOpened({
    required super.topicId,
    required super.accountWalletId,
  });
}

class WalletConnectSessionClosed extends WalletConnectEvent {
  const WalletConnectSessionClosed({
    required super.topicId,
    required super.accountWalletId,
  });
}

abstract class WalletConnectRequest extends WalletConnectEvent {
  final int requestId;

  const WalletConnectRequest({
    required super.topicId,
    required super.accountWalletId,
    required this.requestId,
  });
}

class WalletConnectSessionRequest extends WalletConnectRequest {
  final WalletConnectPeer peer;
  final int networkId;

  const WalletConnectSessionRequest({
    required super.topicId,
    required super.accountWalletId,
    required super.requestId,
    required this.peer,
    required this.networkId,
  });

  WalletConnectSessionRequest copyWith({
    int? networkId,
  }) {
    return WalletConnectSessionRequest(
      topicId: topicId,
      accountWalletId: accountWalletId,
      requestId: requestId,
      peer: peer,
      networkId: networkId ?? this.networkId,
    );
  }
}

abstract class WalletConnectDataRequest extends WalletConnectRequest {
  final String data;

  const WalletConnectDataRequest({
    required super.topicId,
    required super.accountWalletId,
    required super.requestId,
    required this.data,
  });

  WalletConnectDataRequest copyWith({String? data});
}

enum SignRequestType {
  message,
  personalMessage,
  typedMessage,
}

class WalletConnectSignatureRequest extends WalletConnectDataRequest {
  final WalletConnectPeer peer;
  final SignRequestType type;
  final int networkId;

  const WalletConnectSignatureRequest({
    required super.topicId,
    required super.accountWalletId,
    required super.requestId,
    required this.peer,
    required this.networkId,
    required this.type,
    super.data = '',
  });

  @override
  WalletConnectSignatureRequest copyWith({String? data}) {
    return WalletConnectSignatureRequest(
      topicId: topicId,
      accountWalletId: accountWalletId,
      requestId: requestId,
      peer: peer,
      networkId: networkId,
      type: type,
      data: data ?? this.data,
    );
  }
}

enum TransactionRequestType {
  sign,
  send,
}

class WalletConnectTransactionRequest extends WalletConnectDataRequest {
  final TransactionRequestType type;
  final WalletConnectPeer peer;
  final String fromAddress;
  final String toAddress;
  final int networkId;
  final int chainId;
  final int assetId;
  final BigInt amount;
  final BigInt? nonce;
  final BigInt? gasPrice;
  final BigInt? gas;
  final BigInt? gasLimit;

  const WalletConnectTransactionRequest({
    required super.topicId,
    required super.accountWalletId,
    required super.requestId,
    required this.type,
    required this.peer,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.networkId,
    required this.chainId,
    required this.assetId,
    this.nonce,
    this.gasPrice,
    this.gas,
    this.gasLimit,
    super.data = '',
  });

  bool get isComplete => gasPrice != null && (gas != null || gasLimit != null);

  BigInt? get gasMaxAmount {
    if (gas != null && gasLimit != null) {
      return BigInt.from(max(gas!.toDouble(), gasLimit!.toDouble()));
    }

    return gasLimit ?? gas;
  }

  @override
  WalletConnectTransactionRequest copyWith({String? data}) {
    return WalletConnectTransactionRequest(
      topicId: topicId,
      accountWalletId: accountWalletId,
      requestId: requestId,
      type: type,
      peer: peer,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      networkId: networkId,
      chainId: chainId,
      assetId: assetId,
      gas: gas,
      gasLimit: gasLimit,
      gasPrice: gasPrice,
      nonce: nonce,
      data: data ?? this.data,
    );
  }
}

class WalletConnectPeer {
  final String name;
  final String url;
  final List<String> icons;
  final String description;

  const WalletConnectPeer({
    required this.name,
    required this.url,
    this.icons = const [],
    this.description = '',
  });
}

abstract class WalletConnectSessionDb {
  Future<void> save(WalletConnectSessionLocal session);
  List<WalletConnectSessionLocal> getAll(String accountWalletId);
  Future<void> remove(String topicId);
}
