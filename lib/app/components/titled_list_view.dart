import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';

class TitledListView extends StatelessWidget {
  const TitledListView(
    this.title, {
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  final String title;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView.separated(
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
