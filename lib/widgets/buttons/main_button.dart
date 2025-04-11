import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_toy_shop/config/get_it.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/soundpool_manager.dart';
import 'package:virtual_toy_shop/widgets/text/shadow_text.dart';
import 'package:soundpool/soundpool.dart';

class MainButton extends StatefulWidget {
  const MainButton({
    Key? key,
    this.height,
    this.width = double.infinity,
    this.padding = EdgeInsets.zero,
    this.shadowColor = MyColors.orangeShadow,
    this.mainColor = MyColors.orangeLight,
    required this.onTap,
    this.shadowValue = 3,
    this.label,
    this.icon,
    this.isColumn = false,
    this.iconSize = 23,
    this.textSize = 18,
    this.iconColor = Colors.white,
    this.soundName = 'Button',
    this.iconPadding = 0.0,
    this.isActive = true,
    this.pressed = false,
  }) : super(key: key);

  final double? height;
  final double width;
  final EdgeInsets padding;
  final Color shadowColor;
  final Color mainColor;
  final Color iconColor;
  final Function onTap;
  final double shadowValue;
  final String? icon;
  final String? label;
  final bool isColumn;

  final bool pressed;
  final double iconSize;
  final double textSize;
  final String soundName;
  final double iconPadding;
  final bool isActive;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool isTapped = false;


  bool get buttonPressed => isTapped || widget.pressed;



  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (widget.isActive) {
          HapticFeedback.lightImpact();
          getIt<SoundpoolManager>().play(soundName: widget.soundName);
          widget.onTap();
        }
      },
      onTapDown: (details) {
        if (widget.isActive) {
          setState(() {
            isTapped = true;
          });
        }
      },
      onTapUp: (details) {
        if (widget.isActive) {
          setState(() {
            isTapped = false;
          });
        }
      },
      onTapCancel: () {
        if (widget.isActive) {
          setState(() {
            isTapped = false;
          });
        }
      },
      child: Opacity(
        opacity: widget.isActive ? 1 : 0.5,
        child: Container(
          width: widget.width,
          height: widget.height ?? MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.shadowColor, widget.mainColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: widget.padding,
              width: widget.width,
              height: widget.height ??
                  MediaQuery.of(context).size.height * 0.07 -
                      widget.shadowValue,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.shadowColor, widget.mainColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: widget.mainColor,
                    offset: Offset(
                        0, buttonPressed ? -widget.shadowValue : widget.shadowValue),
                  ),
                  BoxShadow(
                    color: buttonPressed ? widget.mainColor : widget.shadowColor,
                    offset: Offset(0, widget.shadowValue),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(top: buttonPressed ? 6.0 : 3.0),
                child: Center(
                  child: widget.isColumn ? columnChild() : rowChild(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rowChild() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.icon != null
            ? Padding(
                padding: EdgeInsets.only(bottom: widget.iconPadding),
                child: Image.asset(
                  'assets/icons/${widget.icon}.png',
                  height: MediaQuery.of(context).size.height *
                      (0.13 * widget.iconSize / 110),
                  //color: widget.iconColor,
                ),
              )
            : const SizedBox(),
        SizedBox(width: widget.label != null && widget.icon != null ? 5 : 0),
        widget.label != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ShadowText(
                  text: widget.label!,
                  size: MediaQuery.of(context).size.height *
                      (0.13 * widget.textSize / 110),
                  textColor: Colors.white,
                  shadowColor: MyColors.darkGray.withOpacity(0.8),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Column columnChild() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.icon != null
            ? Image.asset(
                'assets/icons/${widget.icon}.png',
                height: MediaQuery.of(context).size.height *
                    (0.13 * widget.iconSize / 110),
                //color: widget.iconColor,
              )
            : const SizedBox(),
        SizedBox(height: widget.label != null && widget.icon != null ? 4 : 0),
        widget.label != null
            ? ShadowText(
                text: widget.label!,
                size: MediaQuery.of(context).size.height *
                    (0.13 * widget.textSize / 110),
                textColor: Colors.white,
                shadowColor: MyColors.darkGray.withOpacity(0.8),
              )
            : const SizedBox(),
      ],
    );
  }
}
