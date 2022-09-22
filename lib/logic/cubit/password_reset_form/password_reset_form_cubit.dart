import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/helpers/validated_email.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';

part 'password_reset_form_state.dart';

class PasswordResetFormCubit extends Cubit<PasswordResetFormState> {
  final AuthRepository _authRepository;

  PasswordResetFormCubit._(
    this._authRepository,
  ) : super(const PasswordResetFormState.init());

  PasswordResetFormCubit.builder({
    required AuthRepository authRepository,
  }) : this._(authRepository);

  void changeFormValue({String? email}) {
    emit(state.copyWith(
      email: email,
    ));
  }

  Future<void> submitForm() async {
    emit(state.copyWith(
      response: const PasswordResetFormPending(),
    ));

    try {
      final email = state.email;

      await _authRepository.resetPassword(
        email.toString(),
      );

      emit(state.copyWith(
        response: const PasswordResetFormSuccess(),
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        response: PasswordResetFormFailure(exception: e),
      ));
    }
  }
}
