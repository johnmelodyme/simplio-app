import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/logic/bloc/nft/nft_bloc.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/nft_item.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';

class DiscoveryNftContent extends StatefulWidget {
  const DiscoveryNftContent({super.key});

  @override
  State<DiscoveryNftContent> createState() => _DiscoveryNftContentState();
}

class _DiscoveryNftContentState extends State<DiscoveryNftContent> {
  late NftBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = context.read<NftBloc>();
    bloc.pagingController.addPageRequestListener(_paginateNft);
  }

  @override
  void dispose() {
    super.dispose();

    bloc.pagingController.removePageRequestListener(_paginateNft);
  }

  void _paginateNft(int page) {
    bloc.add(NftLoaded(page: page));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NftBloc, NftState>(
      listener: (context, state) {
        final ctrl = bloc.pagingController;

        if (state is NftInitial) return ctrl.refresh();

        if (state is NftLoadSuccess) {
          if (state.isLastPage) return ctrl.appendLastPage(state.items);
          return ctrl.appendPage(state.items, state.nextPage);
        }

        if (state is NftLoadFailure) {
          ctrl.error = state.error;
          return;
        }
      },
      child: SliverPadding(
        padding: Paddings.horizontal16,
        sliver: BlocBuilder<NftBloc, NftState>(
          builder: (context, state) => PagedSliverList.separated(
            pagingController: bloc.pagingController,
            builderDelegate: PagedChildBuilderDelegate<SearchNftItem>(
              itemBuilder: (context, nft, index) {
                return NftItem(
                  nft: nft,
                  nftAction: const [
                    NftAction.buyNft,
                  ],
                  onActionPressed: print,
                );
              },
              firstPageProgressIndicatorBuilder: (_) => Column(children: const [
                Center(child: ListLoading()),
                Spacer(),
              ]),
              newPageProgressIndicatorBuilder: (_) => const Center(
                  child: Padding(
                padding: Paddings.bottom32,
                child: ListLoading(),
              )),
              firstPageErrorIndicatorBuilder: (_) => TapToRetryLoader(
                isLoading: state is NftLoadInProgress,
                loadingIndicator: const Center(
                  child: Padding(
                    padding: Paddings.bottom32,
                    child: ListLoading(),
                  ),
                ),
                onTap: () {
                  bloc.add(const NftRefreshed());
                },
              ),
              noMoreItemsIndicatorBuilder: (_) => Gaps.gap20,
              noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
              newPageErrorIndicatorBuilder: (_) => Padding(
                padding: Paddings.bottom32,
                child: TapToRetryLoader(
                  isLoading: state is NftLoadInProgress,
                  loadingIndicator: const Center(
                    child: Padding(
                      padding: Paddings.bottom32,
                      child: ListLoading(),
                    ),
                  ),
                  onTap: () {
                    bloc.add(NftLoaded(
                      page: bloc.pagingController.nextPageKey!,
                    ));
                  },
                ),
              ),
            ),
            separatorBuilder: (context, index) => Gaps.gap10,
          ),
        ),
      ),
    );
  }
}
