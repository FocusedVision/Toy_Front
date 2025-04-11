import 'package:flutter/material.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/widgets/text/shadow_text.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    Key? key,
    required this.label,
    this.titleIcon,
    this.action = const SizedBox(),
    this.isBackButton = false,
  }) : super(key: key);

  final String label;
  final Widget action;
  final bool isBackButton;
  final String? titleIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top, 20, 0),
      height: MediaQuery.of(context).size.height * 0.075 +
          MediaQuery.of(context).padding.top,
      decoration: const BoxDecoration(color: MyColors.background),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 40) * 0.3,
              child: titleIcon != null ? title(context) : const SizedBox(),
            ),
            logo(context),
            SizedBox(
                width: (MediaQuery.of(context).size.width - 40) * 0.3,
                child: actionButton()),
          ],
        ),
      ),
    );
  }

  Widget title(BuildContext context) => Row(
        children: [
          Image.asset(
            "assets/icons/$titleIcon.png",
            height: MediaQuery.of(context).size.height * 0.028,
            color: MyColors.darkGray,
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            label,
            style: h6TextStyle.copyWith(
                fontSize: MediaQuery.of(context).size.height * 0.015),
          )
        ],
      );

  Widget logo(BuildContext context) => Expanded(
        child: Image.asset(
          "assets/logo.png",
          height: MediaQuery.of(context).size.height * 0.066,
        ),
      );

  Widget actionButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: action,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height *
              0.066 +
          25);
}
