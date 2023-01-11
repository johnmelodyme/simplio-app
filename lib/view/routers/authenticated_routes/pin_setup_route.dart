import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/logic/cubit/pin_setup_form/pin_setup_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/pin_setup_screen.dart';

class PinSetupRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'pin-setup';
  static const path = 'pin-setup';

  const PinSetupRoute({
    required super.navigator,
    super.routes,
  });

  @override
  GoRoute get route {
    return GoRoute(
      path: path,
      name: name,
      parentNavigatorKey: navigator,
      routes: routes,
      pageBuilder: pageBuilder(
        builder: (state) => BlocProvider(
          create: (context) => PinSetupFormCubit.builder(
            accountRepository:
                RepositoryProvider.of<AccountRepository>(context),
          ),
          child: const PinSetupScreen(),
        ),
      ),
    );
  }
}
