import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/transaction.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/date_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';
import 'package:sio_glyphs/sio_icons.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    super.key,
    required this.transaction,
    required this.currency,
  });

  final String currency;
  final Transaction transaction;

  final Map<TransactionType, IconData> transactionIcons = {
    TransactionType.send: SioIcons.east,
    TransactionType.receive: SioIcons.west,
    TransactionType.swap: SioIcons.swap,
    TransactionType.purchase: SioIcons.south,
    TransactionType.earning: SioIcons.north_east,
  };

  Color getColorByTransactionType(
      BuildContext context, TransactionType transactionType) {
    switch (transactionType) {
      case TransactionType.send:
        return SioColors.highlight;
      case TransactionType.receive:
        return SioColors.nft;
      case TransactionType.swap:
        return SioColors.mentolGreen;
      case TransactionType.purchase:
        return SioColors.games;
      case TransactionType.earning:
        return SioColors.earningStart;
      default:
        // TODO - assign a correct values for unknown transactions
        return SioColors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: Paddings.horizontal16,
      decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(RadiusSize.radius20)),
          color: SioColors.backGradient4Start,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SioColors.backGradient4Start, SioColors.softBlack])),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            transactionIcons[transaction.transactionType],
            size: 16,
            color:
                getColorByTransactionType(context, transaction.transactionType),
          ),
          Gaps.gap10,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.name,
                      style:
                          SioTextStyles.bodyL.apply(color: SioColors.whiteBlue),
                    ),
                    CurrencyText(
                      BigDecimal.fromDouble(
                        transaction.volume,
                      ),
                      style: SioTextStyles.bodyL.apply(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.datetime.getDateFormatShort(),
                      style: SioTextStyles.bodyS.apply(
                        color: SioColors.secondary7,
                      ),
                    ),
                    CurrencyText(
                      BigDecimal.fromDouble(
                        transaction.volume,
                      ),
                      currency: currency,
                      style: SioTextStyles.bodyL.apply(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                  ],
                ),
                if (transaction.transactionStatus != null) ...[
                  Gaps.gap2,
                  Text(
                    context.locale.common_transaction_type(
                      transaction.transactionStatus!.name,
                    ),
                    style: SioTextStyles.bodyDetail.apply(
                      color: getColorByTransactionType(
                          context, transaction.transactionType),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
