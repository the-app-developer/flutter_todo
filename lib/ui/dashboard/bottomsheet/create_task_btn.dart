import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app/common/assets.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateTaskButton extends StatefulWidget {
  Color bgColor;
  Color textColor;
  Color iconTintColor;
  Color shadowColor;
  String title;
  final VoidCallback onTapCallBack;
  CreateTaskButton({
    Key? key,
    required this.bgColor,
    required this.textColor,
    required this.iconTintColor,
    required this.shadowColor,
    required this.title,
    required this.onTapCallBack,
  }) : super(key: key);

  @override
  _CreateTaskButtonState createState() => _CreateTaskButtonState();
}

class _CreateTaskButtonState extends State<CreateTaskButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: widget.bgColor,
          shadowColor: widget.shadowColor,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: () {
        widget.onTapCallBack.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            AppAssets.addIcon,
            color: widget.iconTintColor,
          ).wh(25, 25),
          
          const SizedBox(
            height: 0,
            width: 10,
          ),
          widget.title.text.lg
              .textStyle(TextStyle(color: widget.textColor))
              .bold
              .center
              .make(),
        ],
      ),
    ).wh(170, 50);
  }
}
