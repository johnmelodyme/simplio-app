import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dialog_state.dart';

class DialogCubit extends Cubit<DialogState> {
  DialogCubit._() : super(const DialogState.init());

  DialogCubit.builder() : this._();

  late Function(bool proceed)? _executeAction;

  void showDialog(
      Function(bool proceed) callbackAction, DialogType dialogType) {
    emit(state.copyWith(displayed: true, dialogType: dialogType));
    _executeAction = callbackAction;
  }

  void hideDialog() {
    emit(state.copyWith(displayed: false));
    _executeAction = null;
  }

  void onActionTap(bool proceed) async {
    await _executeAction!(proceed);

    hideDialog();
  }
}
