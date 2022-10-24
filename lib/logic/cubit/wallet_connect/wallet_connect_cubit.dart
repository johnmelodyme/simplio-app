import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/fee_repository.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';

part 'wallet_connect_state.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  final WalletConnectRepository _walletConnectRepository;
  final WalletRepository _walletRepository;
  final FeeRepository _feeRepository;

  StreamSubscription<WalletConnectEvent>? _events;

  WalletConnectCubit._(
    this._feeRepository,
    this._walletConnectRepository,
    this._walletRepository,
  ) : super(const WalletConnectState(requests: {}, sessions: {})) {
    _events = _walletConnectRepository.events.listen((event) {
      if (event is WalletConnectRequest) {
        emit(state.addRequest(event));
        SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
      }

      if (event is WalletConnectSessionClosed) {
        emit(state.copyWith(
          sessions: _walletConnectRepository.sessions,
        ));
      }

      if (event is WalletConnectSessionOpened) {
        emit(state.copyWith(
          sessions: _walletConnectRepository.sessions,
        ));
      }
    });
  }

  WalletConnectCubit({
    required FeeRepository feeRepository,
    required WalletConnectRepository walletConnectRepository,
    required WalletRepository walletRepository,
  }) : this._(feeRepository, walletConnectRepository, walletRepository);

  void loadSessions(String accountWalletId) {
    _walletConnectRepository.loadSessions(accountWalletId);
  }

  Future<void> openSession(
    String accountWalletId, {
    required String uri,
  }) async {
    try {
      await _walletConnectRepository.openSession(
        accountWalletId,
        uri: uri,
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> approveSessionRequest(
    WalletConnectSessionRequest request, {
    int? networkId,
  }) async {
    final walletAddress = _walletRepository.getCoinAddress(
      request.accountWalletId,
      networkId: request.networkId,
    );

    await _walletConnectRepository.approveSessionRequest(
      request,
      walletAddress: walletAddress,
      chainId: AssetRepository.chainId(
        networkId: networkId ?? request.networkId,
      ),
    );

    emit(state.removeRequest(request));
  }

  void rejectRequest(WalletConnectRequest request) {
    _walletConnectRepository.rejectRequest(request);

    emit(state.removeRequest(request));
  }

  void rejectSessionRequest(WalletConnectSessionRequest request) {
    _walletConnectRepository.rejectSessionRequest(request);
    emit(state.removeRequest(request));
  }

  void approveSignatureRequest(
    WalletConnectSignatureRequest request,
  ) {
    String signedDataHex = '';

    switch (request.type) {
      case SignRequestType.message:
        signedDataHex = _walletRepository.signMessage(
          networkId: request.networkId,
          message: request.data,
        );
        break;
      case SignRequestType.personalMessage:
        signedDataHex = _walletRepository.signPersonalMessage(
          networkId: request.networkId,
          message: request.data,
        );
        break;
      case SignRequestType.typedMessage:
        signedDataHex = _walletRepository.signTypedData(
          networkId: request.networkId,
          jsonData: request.data,
        );
        break;
    }

    if (signedDataHex.isEmpty) return;

    _walletConnectRepository.approveDataRequest(
      request.copyWith(data: signedDataHex),
    );

    emit(state.removeRequest(request));
  }

  Future<void> approveTransactionRequest(
    WalletConnectTransactionRequest request,
  ) async {
    final fees = await _feeRepository.loadFees(
      assetId: request.assetId,
      networkId: request.networkId,
    );

    final tx = await _walletRepository.signEthereumTransaction(
      request.accountWalletId,
      networkId: request.networkId,
      toAddress: request.toAddress,
      amount: request.amount,
      feeAmount: request.gasPrice ?? fees.max,
      gasLimit: request.gasMaxAmount ?? fees.gasLimit,
      data: request.data,
    );

    if (tx == null) {
      throw Exception('Transaction does not exist');
    }

    if (request.type == TransactionRequestType.send) {
      final txid = await _walletRepository.broadcastTransaction(tx);

      _walletConnectRepository.approveDataRequest(
        request.copyWith(data: txid),
      );
    }

    if (request.type == TransactionRequestType.sign) {
      _walletConnectRepository.approveDataRequest(
        request.copyWith(data: tx.rawTx),
      );
    }

    emit(state.removeRequest(request));
  }

  void closeSession(String topicId) {
    _walletConnectRepository.closeSession(topicId);
  }

  @override
  Future<void> close() async {
    await _events?.cancel();
    super.close();
  }
}
