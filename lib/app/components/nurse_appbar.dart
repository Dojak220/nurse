import "package:flutter/material.dart";
import "package:nurse/app/theme/app_colors.dart";
import "package:nurse/app/utils/strings_and_styles.dart";

class NurseAppBar extends StatelessWidget with PreferredSizeWidget {
  const NurseAppBar({
    Key? key,
    required this.title,
    this.toolbarHeight,
    this.imageHeight = 44,
    this.titleFontSize,
    this.imageFit = BoxFit.contain,
  }) : super(key: key);

  final String title;
  final double? toolbarHeight;
  final double imageHeight;
  final double? titleFontSize;
  final BoxFit? imageFit;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: AppColors.verdeClaro,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Image.asset(
            "assets/images/nurse-logo-2.png",
            height: imageHeight,
            width: imageHeight,
            fit: imageFit ?? BoxFit.cover,
          ),
        ),
      ],
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LimitedBox(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              title,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: adjustFontSize(title, titleFontSize ?? 32),
              ),
            ),
          ),
        ],
      ),
      iconTheme: const IconThemeData(color: AppColors.black),
      toolbarHeight: toolbarHeight ?? MediaQuery.of(context).size.height * 0.15,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 114.0);
}
