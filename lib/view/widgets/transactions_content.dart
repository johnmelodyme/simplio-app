import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/models/transaction.dart';
import 'package:simplio_app/data/repositories/transaction_repository.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/transactions/transactions_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/empty_list_placeholder.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';
import 'package:simplio_app/view/widgets/transaction_item.dart';

// TODO - move it to a screen as a private widget as it is not reusable.
class TransactionsContent extends StatefulWidget {
  const TransactionsContent({super.key});

  @override
  State<TransactionsContent> createState() => _TransactionsContentState();
}

class _TransactionsContentState extends State<TransactionsContent> {
  TransactionsCubit? cubit;

  void addLoadEvent(int offset) {
    cubit?.loadTransactions(offset);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: Paddings.horizontal16,
      sliver: BlocProvider<TransactionsCubit>(
        create: (_) {
          cubit = TransactionsCubit.builder(
              transactionRepository:
                  RepositoryProvider.of<TransactionRepository>(context))
            ..pagingController.addPageRequestListener(addLoadEvent);
          return cubit!;
        },
        child: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            return PagedSliverList.separated(
              pagingController: cubit!.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Transaction>(
                itemBuilder: (context, item, index) {
                  return TransactionItem(
                    transaction: item,
                    // TODO - replace with the actual currency.
                    currency: 'USD',
                  );
                },
                firstPageProgressIndicatorBuilder: (_) =>
                    Column(children: const [
                  Center(child: ListLoading()),
                  Spacer(),
                ]),
                newPageProgressIndicatorBuilder: (_) => const Center(
                    child: Padding(
                  padding: Paddings.bottom32,
                  child: ListLoading(),
                )),
                firstPageErrorIndicatorBuilder: (_) => TapToRetryLoader(
                  isLoading: state is TransactionsLoadingState,
                  loadingIndicator: const Center(
                    child: Padding(
                      padding: Paddings.bottom32,
                      child: ListLoading(),
                    ),
                  ),
                  onTap: () {
                    cubit?.reloadTransactions();
                  },
                ),
                noMoreItemsIndicatorBuilder: (_) => Gaps.gap20,
                noItemsFoundIndicatorBuilder: (_) => EmptyListPlaceholder(
                  label: context.locale
                      .inventory_screen_search_transactions_no_items_found,
                  child: Image.asset(
                    'assets/images/empty_transactions_placeholder.png',
                  ),
                ),
                newPageErrorIndicatorBuilder: (_) => Padding(
                  padding: Paddings.bottom32,
                  child: TapToRetryLoader(
                    isLoading: state is TransactionsLoadingState,
                    loadingIndicator: const Center(
                      child: Padding(
                        padding: Paddings.bottom32,
                        child: ListLoading(),
                      ),
                    ),
                    onTap: () {
                      cubit?.loadTransactions(
                          cubit!.pagingController.nextPageKey!);
                    },
                  ),
                ),
              ),
              separatorBuilder: (context, index) => Gaps.gap10,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    cubit?.pagingController.removePageRequestListener(addLoadEvent);
    super.dispose();
  }
}
