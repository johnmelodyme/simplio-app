import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

class ListLoading extends StatelessWidget {
  const ListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 35,
      child: CircularProgressIndicator(
        strokeWidth: Dimensions.padding2,
        color: Theme.of(context).colorScheme.outline,
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
    );
  }
}
