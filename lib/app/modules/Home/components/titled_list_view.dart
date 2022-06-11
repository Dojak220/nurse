import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/modules/Home/components/entry_card.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';

class TitledListView extends StatelessWidget {
  TitledListView(
    this.title, {
    Key? key,
    required this.applications,
  }) : super(key: key);

  final String title;
  final List<Application> applications;

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
            height: MediaQuery.of(context).size.height * 0.50,
            child: Observer(builder: (_) {
              return ListView.separated(
                itemCount: applications.length,
                itemBuilder: ((_, i) {
                  return EntryCard(
                    cns: applications[i].patient.cns,
                    name: applications[i].patient.person.name,
                    vaccine: applications[i].vaccineBatch.vaccine.name,
                    group: applications[i]
                        .patient
                        .priorityCategory
                        .priorityGroup
                        .name,
                    pregnant: applications[i].patient.maternalCondition.name,
                  );
                }),
                separatorBuilder: (context, index) => SizedBox(height: 10),
              );
            }),
          ),
        ],
      ),
    );
  }
}
