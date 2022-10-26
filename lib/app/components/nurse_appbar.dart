import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';

class NurseAppBar extends StatelessWidget with PreferredSizeWidget {
  const NurseAppBar({
    Key? key,
    required this.title,
    this.toolbarHeight,
    this.imageHeight = 44,
    this.titleFontSize,
  }) : super(key: key);

  final String title;
  final double? toolbarHeight;
  final double imageHeight;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/nurse-logo-2.png", height: imageHeight),
          Text(title, style: TextStyle(fontSize: titleFontSize)),
        ],
      ),
      iconTheme: const IconThemeData(color: AppColors.black),
      toolbarHeight: toolbarHeight ?? MediaQuery.of(context).size.height * 0.15,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 114.0);
}
