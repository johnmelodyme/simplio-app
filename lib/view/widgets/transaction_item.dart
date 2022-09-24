import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/model/transaction.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/date_extensions.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  final Map<TransactionType, IconData> transactionIcons = {
    TransactionType.send: Icons.east,
    TransactionType.receive: Icons.west,
    TransactionType.swap: Icons.swap_horiz,
    TransactionType.purchase: Icons.arrow_downward,
    TransactionType.earning: Icons.north_east,
  };

  Color getColorByTransactionType(
      BuildContext context, TransactionType transactionType) {
    switch (transactionType) {
      case TransactionType.send:
        return Theme.of(context).colorScheme.onTertiary;
      case TransactionType.receive:
        return Theme.of(context).colorScheme.onSurface;
      case TransactionType.swap:
        return Theme.of(context).colorScheme.secondaryContainer;
      case TransactionType.purchase:
        return Theme.of(context).colorScheme.onBackground;
      case TransactionType.earning:
        return Theme.of(context).colorScheme.onError;
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
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.onPrimaryContainer,
                Theme.of(context).colorScheme.background
              ])),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            transactionIcons[transaction.transactionType],
            color:
                getColorByTransactionType(context, transaction.transactionType),
          ),
          const Gap(Dimensions.padding10),
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
                      style: SioTextStyles.bodyL,
                    ),
                    Text(
                      transaction.volume.getThousandSeparatedValue(),
                      style: SioTextStyles.bodyL,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.datetime.getDateFormatShort(),
                      style: SioTextStyles.bodyS.apply(
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                    Text(
                      transaction.price.getThousandValueWithCurrency(
                        currency: 'USD', //TODO.. replace by real currency
                        locale: Intl.getCurrentLocale(),
                      ),
                      style: SioTextStyles.bodyS.apply(
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                  ],
                ),
                if (transaction.transactionStatus != null) ...[
                  const Gap(Dimensions.padding2),
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
