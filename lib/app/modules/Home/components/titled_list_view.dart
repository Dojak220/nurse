import 'package:flutter/material.dart';
import 'package:nurse/app/modules/Home/components/entry_card.dart';
import 'package:nurse/app/theme/app_theme.dart';

class TitledListView extends StatelessWidget {
  TitledListView(
    this.title, {
    Key? key,
    required this.entryList,
  }) : super(key: key);

  final String title;
  final List<EntryCard> entryList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
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
          Container(
            /// TODO: Substituir constraints for height
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.50,
              minHeight: MediaQuery.of(context).size.height * 0.50,
            ),
            child: ListView.separated(
              itemBuilder: ((context, index) => entryList[index]),
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemCount: entryList.length,
            ),
          ),
        ],
      ),
    );
  }
}
