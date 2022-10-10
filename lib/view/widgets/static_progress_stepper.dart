import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/helpers/custom_painters.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

const double _firstStepRadius = 15.5;
const double _otherStepRadius = 12;
const double _stepLength = 75;
const double _yTextOffset = -2;
const double _xTextOffset = 0.5;

enum ProgressBarType { sending, exchanging, buying }

class StaticProgressStepper extends StatelessWidget {
  final ProgressBarType progressBarType;

  const StaticProgressStepper({required this.progressBarType, super.key});

  String _getLabel(BuildContext context, int step) {
    List<String> labels = [];
    switch (progressBarType) {
      case ProgressBarType.sending:
        labels = [
          context.locale.asset_send_success_screen_verification,
          context.locale.asset_send_success_screen_sending,
          context.locale.asset_send_success_screen_paying_out,
          context.locale.asset_send_success_screen_finished,
        ];
        break;
      case ProgressBarType.exchanging:
        labels = [
          context.locale.asset_exchange_success_screen_verification,
          context.locale.asset_exchange_success_screen_exchanging,
          context.locale.asset_exchange_success_screen_paying_out,
          context.locale.asset_exchange_success_screen_finished,
        ];
        break;
      case ProgressBarType.buying:
        labels = [
          context.locale.asset_buy_success_screen_verification,
          context.locale.asset_buy_success_screen_buying,
          context.locale.asset_buy_success_screen_paying_out,
          context.locale.asset_buy_success_screen_finished,
        ];
        break;
    }

    return labels[step - 1];
  }

  Offset _stepNumber(int step) {
    if (step == 1) {
      return const Offset(_xTextOffset, _yTextOffset);
    } else {
      return _circle(step) + _stepNumber(1);
    }
  }

  Offset _circle(int step) {
    if (step == 1) {
      return const Offset(0, 0);
    } else {
      return Offset(
          _firstStepRadius +
              _stepLength * (step - 1) +
              _otherStepRadius * (step * 2 - 3),
          0);
    }
  }

  Offset _lineStart(int step) {
    if (step == 1) {
      return const Offset(_firstStepRadius, 0);
    } else {
      return _circle(step) + const Offset(_otherStepRadius, 0);
    }
  }

  Offset _lineEnd(int step) {
    return _lineStart(step) + const Offset(_stepLength, 0);
  }

  Offset _label(int step) {
    if (step == 1) {
      return _circle(1) + const Offset(2, 35);
    } else {
      return _circle(step) + const Offset(2, 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: CirclePainter(
            center: _circle(1),
            radius: _firstStepRadius,
            color: SioColors.whiteBlue,
          ),
        ),
        CustomPaint(
          painter: SioTextPainter(
            text: '1',
            offset: _stepNumber(1),
            style: SioTextStyles.h5.copyWith(
              color: SioColors.softBlack,
            ),
          ),
        ),
        CustomPaint(
          painter: SioTextPainter(
            text: _getLabel(context, 1),
            offset: _label(1),
            style: SioTextStyles.bodyLargeBold.copyWith(
              color: SioColors.whiteBlue,
            ),
          ),
        ),
        CustomPaint(
          painter: LinePainter(
            color: SioColors.secondary4,
            start: _lineStart(1),
            end: _lineEnd(1),
          ),
        ),
        CustomPaint(
          painter: CirclePainter(
            center: _circle(2),
            radius: _otherStepRadius,
            color: SioColors.secondary4,
          ),
        ),
        CustomPaint(
          painter: SioTextPainter(
            text: '2',
            offset: _stepNumber(2),
            style: SioTextStyles.h5.copyWith(
              color: SioColors.mentolGreen,
            ),
          ),
        ),
        CustomPaint(
          painter: SioTextPainter(
            text: _getLabel(context, 2),
            offset: _label(2),
            style: SioTextStyles.bodyDetail.copyWith(
              color: SioColors.secondary5,
            ),
          ),
        ),
        CustomPaint(
          painter: LinePainter(
            color: SioColors.secondary4,
            start: _lineStart(2),
            end: _lineEnd(2),
          ),
        ),
        CustomPaint(
          painter: CirclePainter(
            center: _circle(3),
            radius: _otherStepRadius,
            color: SioColors.secondary4,
          ),
        ),
        CustomPaint(
          painter: SioTextPainter(
            text: '3',
            offset: _stepNumber(3),
            style: SioTextStyles.h5.copyWith(
              color: SioColors.mentolGreen,
            ),
          ),
        ),
        CustomPaint(
          painter: SioTextPainter(
            text: _getLabel(context, 3),
            offset: _label(3),
            style: SioTextStyles.bodyDetail.copyWith(
              color: SioColors.secondary5,
            ),
          ),
        ),
        CustomPaint(
          painter: LinePainter(
            color: SioColors.secondary4,
            start: _lineStart(3),
            end: _lineEnd(3),
          ),
        ),
        CustomPaint(
          painter: CirclePainter(
            center: _circle(4),
            radius: _otherStepRadius,
            color: SioColors.secondary4,
          ),
        ),
        CustomPaint(
          painter: SioTextPainter(
            text: '4',
            offset: _stepNumber(4),
            style: SioTextStyles.h5.copyWith(
              color: SioColors.mentolGreen,
            ),
          ),
        ),
        CustomPaint(
          painter: SioTextPainter(
            text: _getLabel(context, 4),
            offset: _label(4),
            style: SioTextStyles.bodyDetail.copyWith(
              color: SioColors.secondary5,
            ),
          ),
        ),
      ],
    );
  }
}
