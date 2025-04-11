import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/widgets/text/shadow_text.dart';

class WishlistTile extends StatelessWidget {
  const WishlistTile({
    Key? key,
    required this.label,
    required this.image,
  }) : super(key: key);

  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(12),
      width: size.width - 32,
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
        color: MyColors.background,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(2, 3),
            color: Color.fromRGBO(0, 0, 0, 0.06),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.24,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7.0),
                bottomLeft: Radius.circular(7.0),
              ),
              image:
                  DecorationImage(image: CachedNetworkImageProvider(image), fit: BoxFit.fill),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              label,
              style: h4TextStyle.copyWith(
                color: MyColors.darkGray,
                fontSize:
                    MediaQuery.of(context).size.height * (0.13 * 16 / 110),
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
