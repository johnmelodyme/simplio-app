part of 'tab_bar_cubit.dart';

class TabBarState extends Equatable {
  final bool isDisplayed;
  final Key selectedItem;

  const TabBarState._({
    required this.isDisplayed,
    required this.selectedItem,
  });

  const TabBarState.init()
      : this._(
          isDisplayed: true,
          selectedItem: const ValueKey('none'),
        );

  @override
  List<Object?> get props => [
        isDisplayed,
        selectedItem,
      ];

  TabBarState copyWith({
    bool? isDisplayed,
    Key? selectedItem,
  }) {
    return TabBarState._(
      isDisplayed: isDisplayed ?? this.isDisplayed,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }
}
