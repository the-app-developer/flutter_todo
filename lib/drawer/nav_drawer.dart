import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/drawer/nav_menu.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/archive/archive_screen.dart';
// import 'package:todo_app/ui/archive/archive_screen.dart';
import 'package:todo_app/ui/favourite/favourite_screen.dart';
import 'package:todo_app/ui/wlecome/welcome_screen.dart';
import 'package:todo_app/utils/utility.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = Constant.profileImageUrl;
    String userLoggedName = Constant.fullname;

    return Drawer(
      child: Container(
        color: MyTheme.primaryColor,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: imageProvider),
                            ),
                          ),
                      imageUrl: imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.network(imageUrl)),
                ),
                const SizedBox(
                  height: 20,
                ),
                // username
                "$userLoggedName".text.xl2.bold.white.make(),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 20,
                  color: Colors.white,
                ),

                // list of menu
                NavMenu(
                  title: Strings.home,
                  iconPath: AppAssets.homeIcon,
                  onCustomTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                NavMenu(
                    title: Strings.favourite,
                    iconPath: AppAssets.favouriteIcon,
                    onCustomTap: () {
                      Navigator.of(context).pop();
                      Utils.redirectToScreen(context, const FavouriteScreen());
                    }),
                NavMenu(
                    title: Strings.archive,
                    iconPath: AppAssets.deleteIcon,
                    onCustomTap: () {
                      Navigator.of(context).pop();
                      Utils.redirectToScreen(context, const ArchiveScreen());
                    }),
                NavMenu(
                    title: Strings.logout,
                    iconPath: AppAssets.logoutIcon,
                    onCustomTap: () {
                      Utils.clearPrefLoginData();
                      Utils.redirectToNextScreen(context, const WelomeScreen());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
