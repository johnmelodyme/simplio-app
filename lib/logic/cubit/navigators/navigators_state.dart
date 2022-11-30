part of 'navigators_cubit.dart';

class NavigatorsState extends Equatable {
  final bool appBarDisplayed;
  final bool tabBarDisplayed;
  final Key selectedItem;

  const NavigatorsState._({
    required this.appBarDisplayed,
    required this.tabBarDisplayed,
    required this.selectedItem,
  });

  const NavigatorsState.init()
      : this._(
          appBarDisplayed: true,
          tabBarDisplayed: true,
          selectedItem: const ValueKey('none'),
        );

  @override
  List<Object?> get props => [
        appBarDisplayed,
        tabBarDisplayed,
        selectedItem,
      ];

  NavigatorsState copyWith({
    bool? appBarDisplayed,
    bool? tabBarDisplayed,
    Key? selectedItem,
  }) {
    return NavigatorsState._(
      appBarDisplayed: appBarDisplayed ?? this.appBarDisplayed,
      tabBarDisplayed: tabBarDisplayed ?? this.tabBarDisplayed,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }
}
