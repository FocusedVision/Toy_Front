import 'package:flutter/material.dart';

import '../../config/my_colors.dart';

class CrossIcon extends StatelessWidget {
  const CrossIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.024,
          width: 40,
        ),
        InkWell(
          key: const Key("close_pop_up"),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.028,
            width: 40,
            child: Image.asset(
              'assets/icons/close.png',
              alignment: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
