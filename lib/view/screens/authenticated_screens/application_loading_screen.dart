import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class ApplicationLoadingScreen extends StatelessWidget {
  const ApplicationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: BlocBuilder<AccountWalletCubit, AccountWalletState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  // TODO - create an action that can reasolve the particular error.
                  if (state is AccountWalletLoadedWithError) {
                    return Text(
                      state.error.toString(),
                      style: TextStyle(
                        color: SioColors.attention,
                      ),
                    );
                  }
                  return const ListLoading();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
