import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_cubit.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_state.dart';
import 'package:virtual_toy_shop/presentation/profile/widgets/avatar_selector.dart';
import 'package:virtual_toy_shop/widgets/app_bars/main_app_bar.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';
import 'package:virtual_toy_shop/widgets/text_fields/custom_text_field.dart';

class WelcomeProfileScreen extends StatefulWidget {
  const WelcomeProfileScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeProfileScreen> createState() => _WelcomeProfileScreenState();
}

class _WelcomeProfileScreenState extends State<WelcomeProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      return Scaffold(
        appBar: const MainAppBar(label: ''),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
          child: MainButton(
            onTap: () {
              context
                  .read<ProfileCubit>()
                  .updateUser(state.newName, state.newAvatar)
                  .then((value) {
                if (value != false) {
                  context.read<MainCubit>().toMain();
                }
              });
            },
            label: 'Get started'.toUpperCase(),
            mainColor: MyColors.greenLight,
            shadowColor: MyColors.greenShadow,
            isActive:
                state.newName?.isNotEmpty == true && state.newAvatar != null,
            textSize: 20,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hey! Welcome ',
                          style: h2TextStyle.copyWith(
                              fontFamily: 'VAG Rounded Std',
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.0236),
                        ),
                        TextSpan(
                          text: '👋🏻',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0236,
                            fontFamily: 'EmojiOne',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Choose your avatar:',
                    style: h4TextStyle.copyWith(
                        fontSize: MediaQuery.of(context).size.height * 0.019),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const AvatarSelector(),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Your name:',
                    style: h4TextStyle.copyWith(
                        fontSize: MediaQuery.of(context).size.height * 0.019),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: CustomTextField(
                      initValue: state.user?.name ?? '',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
