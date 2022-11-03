import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expansion_list_state.dart';

class ExpansionListCubit extends Cubit<ExpansionListState> {
  ExpansionListCubit._() : super(const ExpansionListState.init());

  ExpansionListCubit.builder() : this._();

  void selectValue(int selectedIndex) {
    emit(state.copyWith(selectedIndex: selectedIndex));
  }
}
