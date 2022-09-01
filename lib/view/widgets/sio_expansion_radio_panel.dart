import 'package:flutter/material.dart';

const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension;

class SioExpansionRadioPanel extends ExpansionPanelList {
  const SioExpansionRadioPanel({
    super.key,
    super.children,
    super.dividerColor,
    super.expandedHeaderPadding = EdgeInsets.zero,
    super.elevation = 0,
  });

  @override
  State<StatefulWidget> createState() => _ExpansionPanelListState2();
}

class _ExpansionPanelListState2 extends State<ExpansionPanelList> {
  ExpansionPanelRadio? _currentOpenPanel;

  bool _isChildExpanded(int index) {
    final ExpansionPanelRadio radioWidget =
        widget.children[index] as ExpansionPanelRadio;
    return _currentOpenPanel?.value == radioWidget.value;
  }

  void _handlePressed(bool isExpanded, int index) {
    widget.expansionCallback?.call(index, isExpanded);

    final ExpansionPanelRadio pressedChild =
        widget.children[index] as ExpansionPanelRadio;

    // If another ExpansionPanelRadio was already open, apply its
    // expansionCallback (if any) to false, because it's closing.
    for (int childIndex = 0;
        childIndex < widget.children.length;
        childIndex += 1) {
      final ExpansionPanelRadio child =
          widget.children[childIndex] as ExpansionPanelRadio;
      if (widget.expansionCallback != null &&
          childIndex != index &&
          child.value == _currentOpenPanel?.value) {
        widget.expansionCallback!(childIndex, false);
      }

      setState(() {
        _currentOpenPanel = isExpanded ? null : pressedChild;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      kElevationToShadow.containsKey(widget.elevation),
      'Invalid value for elevation. See the kElevationToShadow constant for'
      ' possible elevation values.',
    );

    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];

    for (int index = 0; index < widget.children.length; index += 1) {
      final ExpansionPanel child = widget.children[index];
      final Widget headerWidget = child.headerBuilder(
        context,
        _isChildExpanded(index),
      );

      Widget header = Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index)
                  ? widget.expandedHeaderPadding
                  : EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minHeight: _kPanelHeaderCollapsedHeight),
                child: headerWidget,
              ),
            ),
          ),
        ],
      );
      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: InkWell(
            onTap: () => _handlePressed(_isChildExpanded(index), index),
            child: header,
          ),
        );
      }
      items.add(
        MaterialSlice(
          key: _SaltedKey<BuildContext, int>(context, index * 2),
          color: child.backgroundColor,
          child: Column(
            children: <Widget>[
              header,
              AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: child.body,
                firstCurve:
                    const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve:
                    const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isChildExpanded(index)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
            ],
          ),
        ),
      );
    }

    return MergeableMaterial(
      hasDividers: true,
      dividerColor: widget.dividerColor,
      elevation: widget.elevation,
      children: items,
    );
  }
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _SaltedKey<S, V> &&
        other.salt == salt &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? "<'$salt'>" : '<$salt>';
    final String valueString = V == String ? "<'$value'>" : '<$value>';
    return '[$saltString $valueString]';
  }
}
