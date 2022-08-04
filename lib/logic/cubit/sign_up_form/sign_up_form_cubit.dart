import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/validated_email.dart';
import 'package:simplio_app/data/model/validated_password.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';

part 'sign_up_form_state.dart';

class SignUpFormCubit extends Cubit<SignUpFormState> {
  final AuthRepository _authRepository;

  SignUpFormCubit._(
    this._authRepository,
  ) : super(const SignUpFormState.init());

  SignUpFormCubit.builder({
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
      response: const SignUpFormPending(),
    ));

    try {
      final login = state.login.toString();
      final password = state.password.toString();
      final account = await _authRepository.signUp(login, password);

      emit(state.copyWith(
        response: SignUpFormSuccess(account: account),
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        response: SignUpFormFailure(exception: e),
      ));
    }
  }
}
