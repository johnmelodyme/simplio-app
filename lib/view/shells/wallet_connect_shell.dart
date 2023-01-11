import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/widgets/wallet_connect_request_item.dart';
import 'package:simplio_app/view/widgets/wallet_connect_request_list.dart';

class WalletConnectShell extends StatelessWidget {
  final Widget child;

  const WalletConnectShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        BlocBuilder<WalletConnectCubit, WalletConnectState>(
          buildWhen: (prev, curr) => prev != curr,
          builder: (context, state) => state.isModal
              ? WalletConnectRequestList(
                  children:
                      state.requests.values.map<WalletConnectRequestItem>((r) {
                    if (r is WalletConnectSessionRequest) {
                      return WalletConnectSessionRequestItem(
                        request: r,
                        onApprove: (networkId) {
                          context
                              .read<WalletConnectCubit>()
                              .approveSessionRequest(r, networkId: networkId);
                        },
                        onReject: () {
                          context
                              .read<WalletConnectCubit>()
                              .rejectSessionRequest(r);
                        },
                      );
                    }

                    if (r is WalletConnectSignatureRequest) {
                      return WalletConnectSignatureRequestItem(
                        request: r,
                        onApprove: () {
                          context
                              .read<WalletConnectCubit>()
                              .approveSignatureRequest(r);
                        },
                        onReject: () {
                          context.read<WalletConnectCubit>().rejectRequest(r);
                        },
                      );
                    }

                    if (r is WalletConnectTransactionRequest) {
                      return WalletConnectTransactionRequestItem(
                        request: r,
                        onApprove: () async {
                          await context
                              .read<WalletConnectCubit>()
                              .approveTransactionRequest(r);
                        },
                        onReject: () async {
                          context.read<WalletConnectCubit>().rejectRequest(r);
                        },
                      );
                    }

                    return WalletConnectUnknownEventItem(request: r);
                  }).toList(),
                )
              : Container(),
        )
      ],
    );
  }
}
