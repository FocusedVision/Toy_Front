import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_cubit.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_state.dart';
import 'package:virtual_toy_shop/data/model/avatar.dart';
import 'package:virtual_toy_shop/widgets/containers/custom_avatar.dart';

class AvatarSelector extends StatefulWidget {
  const AvatarSelector({Key? key}) : super(key: key);

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  String selectedAvatarKey = 'key';
  final SwiperController controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => controller.previous(),
                icon: Image.asset(
                  'assets/icons/back_red.png',
                  height: MediaQuery.of(context).size.height * 0.026,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.72 + 16,
                  child: Swiper(
                    controller: controller,
                    itemCount: state.chunkedAvatars?.length ?? 0,
                    loop: false,
                    itemBuilder: (context, wrapIndex) {
                      return Wrap(
                        spacing: 22,
                        runSpacing: 20,
                        children: List.generate(
                          state.chunkedAvatars?[wrapIndex].length ?? 0,
                          (index) {
                            Avatar currentAvatar =
                                state.chunkedAvatars?[wrapIndex][index] ??
                                    Avatar();
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedAvatarKey = currentAvatar.key ?? '';
                                });
                                context
                                    .read<ProfileCubit>()
                                    .setNewAvatar(selectedAvatarKey);
                              },
                              child: CustomAvatar(
                                isSelected:
                                    selectedAvatarKey == currentAvatar.key,
                                size: MediaQuery.of(context).size.width * 0.22,
                                image: currentAvatar.url ?? '',
                              ),
                            );
                          },
                        ),
                      );
                    },
                    viewportFraction: 1.0,
                    scale: 1.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => controller.next(),
                icon: Image.asset(
                  'assets/icons/forward_red.png',
                  height: MediaQuery.of(context).size.height * 0.026,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
