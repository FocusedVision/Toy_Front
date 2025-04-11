import 'package:flutter/material.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppBar({
    Key? key,
    required this.title,
    this.isBackArrow = true,
  }) : super(key: key);

  final String title;
  final bool isBackArrow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.012),
      child: AppBar(
        title: Text(
          title.toUpperCase(),
          style: h2TextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height * 0.0236),
        ),
        centerTitle: true,
        elevation: 0,
        leading: isBackArrow
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Image.asset(
                    "assets/icons/back_black.png",
                    height: MediaQuery.of(context).size.height * 0.0118,
                  ),
                ),
              )
            : const SizedBox(),
        backgroundColor: MyColors.background,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height *
          0.066);
}
