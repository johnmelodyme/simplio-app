import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';

class TapToRetryLoader extends StatefulWidget {
  const TapToRetryLoader({
    super.key,
    this.label,
    required this.loadingIndicator,
    required this.onTap,
    this.isLoading = false,
  });

  final bool isLoading;
  final String? label;
  final Widget loadingIndicator;
  final Function onTap;

  @override
  State<TapToRetryLoader> createState() => _TapToRetryLoaderState();
}

class _TapToRetryLoaderState extends State<TapToRetryLoader> {
  late bool isLoading;

  @override
  void initState() {
    isLoading = widget.isLoading;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? widget.loadingIndicator
        : InkWell(
            onTap: () {
              setState(() {
                isLoading = true;
              });
              widget.onTap.call();
            },
            child: Column(
              children: [
                Text(
                  widget.label ?? context.locale.common_retry,
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.onPrimary,
                )
              ],
            ));
  }
}
