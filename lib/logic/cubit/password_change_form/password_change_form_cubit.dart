import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/validated_password.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';

part 'password_change_form_state.dart';

class PasswordChangeFormCubit extends Cubit<PasswordChangeFormState> {
  final AuthRepository _authRepository;

  PasswordChangeFormCubit._(
    this._authRepository,
  ) : super(const PasswordChangeFormState.init());

  PasswordChangeFormCubit.builder({
    required AuthRepository authRepository,
  }) : this._(authRepository);

  void changeFormValue({
    String? newPassword,
    String? oldPassword,
  }) {
    emit(state.copyWith(
      newPassword: newPassword,
      oldPassword: oldPassword,
    ));
  }

  Future<void> submitForm() async {
    emit(state.copyWith(
      response: const PasswordChangeFormPending(),
    ));

    try {
      final oldPassword = state.oldPassword;
      final newPassword = state.newPassword;

      await _authRepository.changePassword(
        oldPassword.toString(),
        newPassword.toString(),
      );

      emit(state.copyWith(
        response: const PasswordChangeFormSuccess(),
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        response: PasswordChangeFormFailure(exception: e),
      ));
    }
  }
}
