part of 'expansion_list_cubit.dart';

class ExpansionListState extends Equatable {
  final int selectedIndex;
  const ExpansionListState._({this.selectedIndex = -1});

  const ExpansionListState.init() : this._();

  @override
  List<Object?> get props => [selectedIndex];

  ExpansionListState copyWith({
    int? selectedIndex,
  }) {
    return ExpansionListState._(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
