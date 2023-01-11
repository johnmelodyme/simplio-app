import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/helpers/validated_email.dart';
import 'package:simplio_app/logic/helpers/validated_password.dart';

part 'sign_in_form_state.dart';

class SignInFormCubit extends Cubit<SignInFormState> {
  final AuthRepository _authRepository;

  SignInFormCubit._(
    this._authRepository,
  ) : super(const SignInFormState.init());

  SignInFormCubit.builder({
    required AuthRepository authRepository,
  }) : this._(authRepository);

  void changeFormValue({
    String? login,
    String? password,
  }) {
    emit(state.copyWith(
      login: login,
      password: password,
    ));
  }

  Future<void> submitForm() async {
    emit(state.copyWith(
      response: const SignInFormPending(),
    ));

    try {
      final login = state.login.toString();
      final password = state.password.toString();
      final account = await _authRepository.signIn(login, password);

      emit(state.copyWith(
        response: SignInFormSuccess(account: account),
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        response: SignInFormFailure(exception: e),
      ));
    }
  }
}
