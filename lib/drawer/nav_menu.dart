import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class NavMenu extends StatefulWidget {
  final VoidCallback onCustomTap;
  String title = "";
  String iconPath = "";
  NavMenu({
    Key? key,
    required this.onCustomTap,
    required this.title,
    required this.iconPath,
  }) : super(key: key);

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: InkWell(
        onTap: () {
          widget.onCustomTap.call();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(widget.iconPath, height: 30, width: 30),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 0, 7, 0),
              child: widget.title.text
                  .textStyle(const TextStyle(fontSize: 15, color: Colors.white))
                  .bold
                  .make(),
            )
          ],
        ),
      ),
    );
  }
}
