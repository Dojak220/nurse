import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/nurse_appbar.dart';
import 'package:nurse/app/components/registration_button.dart';
import 'package:nurse/app/components/titled_list_view.dart';
import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign_page_controller.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:provider/provider.dart';

class EntityList extends StatelessWidget {
  final String title;
  final String newPage;
  final String buttonText;
  final Widget Function(BuildContext, int) itemBuilder;
  final void Function() onCallback;

  const EntityList({
    Key? key,
    required this.title,
    required this.onCallback,
    required this.newPage,
    required this.buttonText,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NurseAppBar(title: title),
      body: EntityListBuilder(
        title: "$title cadastrada(o)s",
        controller: context.read<CampaignsPageController>(),
        itemBuilder: itemBuilder,
      ),
      floatingActionButton: RegistrationButton(
        text: buttonText,
        newPage: newPage,
        onCallback: onCallback,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class EntityListBuilder extends StatelessWidget {
  const EntityListBuilder({
    Key? key,
    required this.controller,
    required this.title,
    required this.itemBuilder,
  }) : super(key: key);

  final String title;
  final EntityPageController<Campaign> controller;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final entities = controller.entities;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Observer(
        builder: (_) => TitledListView(
          title,
          itemCount: entities.length,
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}
