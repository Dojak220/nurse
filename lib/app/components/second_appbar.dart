import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';

class SecondAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const SecondAppBar({
    Key? key,
    required this.title,
  })  : preferredSize = const Size.fromHeight(1.5 * kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/nurse-logo-1.png",
            height: 44,
          ),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      iconTheme: const IconThemeData(color: AppColors.black),
      toolbarHeight: MediaQuery.of(context).size.height * 0.15,
    );
  }
}
