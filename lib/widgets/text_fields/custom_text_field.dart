import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_cubit.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_state.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    this.initValue = '',
  }) : super(key: key);

  final String initValue;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller = TextEditingController()
      ..text = widget.initValue
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.014,
                horizontal: 16),
            decoration: BoxDecoration(
              color: state.nameError != null
                  ? MyColors.error.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: h1TextStyle.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                ),
                cursorColor: MyColors.darkGray,
                onChanged: (value) {
                  context.read<ProfileCubit>().setNewName(value);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Enter name',
                  hintStyle: h1TextStyle.copyWith(
                    color: MyColors.grayLight,
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          state.nameError != null
              ? Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.014,
                  ),
                  child: Text(
                    'The name was entered incorrectly',
                    style: h6TextStyle.copyWith(
                      color: MyColors.error,
                      fontSize: MediaQuery.of(context).size.height * 0.014,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      );
    });
  }
}
