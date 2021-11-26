import 'package:flutter/material.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:velocity_x/velocity_x.dart';

Widget noTaskDataWidget(
    BuildContext context, String title, String message, String imagePath,double imageHeight) {
  return SingleChildScrollView(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath,
              height: imageHeight),
          const SizedBox(
            height: 20,
          ),
          title.text.bold
              .textStyle(TextStyle(color: MyTheme.primaryColor))
              .xl
              .make(),
          const SizedBox(
            height: 10,
          ),
          message.text.sm
              .textStyle(TextStyle(
                  color: MyTheme.greyColor, fontWeight: FontWeight.bold))
              .center
              .make(),
        ],
      ),
  );
}
