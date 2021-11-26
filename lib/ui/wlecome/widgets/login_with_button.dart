
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget loginWithButtonWidget(
    {required BuildContext context,
    required String title,
    required String iconPath,
    required Color bgColor,
    required Color shadowColor,
    required Function() callback}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: bgColor,
          shadowColor: shadowColor,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: () {
        callback.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(iconPath).wh(25, 25),
            const SizedBox(
              height: 0,
              width: 10,
            ),
            title.text.black.lg.white.bold.center.make(),
          ],
        ),
      )).wh(MediaQuery.of(context).size.width, 50);
}