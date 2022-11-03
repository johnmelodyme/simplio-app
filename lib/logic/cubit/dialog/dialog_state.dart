part of 'dialog_cubit.dart';

enum DialogType { createCoin, removeCoin, cancelEarning, disconnectDApp }

class DialogState extends Equatable {
  final bool displayed;
  final DialogType dialogType;

  const DialogState._({
    this.displayed = false,
    this.dialogType = DialogType.createCoin,
  });

  const DialogState.init() : this._();

  @override
  List<Object?> get props => [displayed, dialogType];

  DialogState copyWith({
    bool? displayed,
    DialogType? dialogType,
  }) {
    return DialogState._(
      displayed: displayed ?? this.displayed,
      dialogType: dialogType ?? this.dialogType,
    );
  }
}
