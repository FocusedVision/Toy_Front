import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/cubit/toy_details/toy_details_cubit.dart';
import 'package:virtual_toy_shop/data/model/product.dart';
import 'package:virtual_toy_shop/widgets/app_bars/main_app_bar.dart';
import 'package:virtual_toy_shop/widgets/pop_ups/confirm_pop_up.dart';
import 'package:virtual_toy_shop/widgets/templates/no_connection.dart';
import 'package:virtual_toy_shop/widgets/tiles/wishlist_tile.dart';
import 'package:virtual_toy_shop/presentation/wishlist/widgets/share_options_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/my_colors.dart';
import '../all_toys/toy_3d_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  ScrollController scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    scrollController = ScrollController()..addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return !state.noConnection
          ? Scaffold(
              extendBodyBehindAppBar: true,
              appBar: buildAppBar(),
              body: state.wishlistProducts != null
                  ? SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: kToolbarHeight + 80,
                          ),
                          ...List.generate(state.wishlistProducts!.length,
                              (index) {
                            Product currentToy = state.wishlistProducts![index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, bottom: 8.0),
                              child: Slidable(
                                key: Key('${currentToy.id}'),
                                endActionPane: ActionPane(
                                  extentRatio: 0.25,
                                  motion: const BehindMotion(),
                                  children: [
                                    deleteButton(currentToy.id ?? -1),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    goToToy(currentToy.id ?? -1,
                                        currentToy.name ?? '');
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: WishlistTile(
                                    image: currentToy.image ?? '',
                                    label: currentToy.name ?? '',
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.orangeShadow,
                      ),
                    ),
            )
          : Scaffold(
              body: NoConnection(),
            );
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Wishlist'),
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/icons/share.png',
            height: 24,
          ),
          onPressed: () => _shareWishlist(),
        ),
      ],
    );
  }

  void _shareWishlist() async {
    try {
      final response = await context.read<MainCubit>().getWishlistShareLink();
      print("1111111111111111111111111111111111111 + ${response}");
      if (response != null &&
          response['share_url'] != null &&
          response['products_count'] != null) {
        if (!mounted) return;

        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => ShareOptionsBottomSheet(
            shareUrl: response['share_url'].toString(),
            productCount: response['products_count'] as int,
          ),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to generate share link'),
            backgroundColor: MyColors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sharing wishlist'),
          backgroundColor: MyColors.orange,
        ),
      );
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Widget deleteButton(int id) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.25 - 8,
      color: const Color(0xFFFB4D4D).withOpacity(0.1),
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => ConfirmPopUp(
                label: 'Confirm deletion',
                onTap: () {
                  context.read<MainCubit>().removeFromWishlist(id);
                },
              ),
            );
          },
          child: SizedBox(
            height: 80,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/icons/trash.png',
                height: MediaQuery.of(context).size.height * 0.026,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void scrollListener() {
    //load more data
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !isLoading) {
      isLoading = true;
      context.read<MainCubit>().getNewWishlistProducts().then((value) {
        isLoading = false;
      });
    }
  }

  void goToToy(int id, String name) {
    context.read<ToyDetailsCubit>().getToyById(id);
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: Toy3D(title: name),
      ),
    );
  }
}
