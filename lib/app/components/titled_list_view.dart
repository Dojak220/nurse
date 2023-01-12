import "package:flutter/material.dart";
import "package:nurse/app/theme/app_theme.dart";

class TitledListView extends StatelessWidget {
  const TitledListView(
    this.title, {
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.maxHeight,
  }) : super(key: key);

  final String title;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: AppTheme.titleTextStyle,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}
