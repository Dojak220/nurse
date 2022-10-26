import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/nurse_appbar.dart';
import 'package:nurse/app/components/registration_button.dart';
import 'package:nurse/app/components/titled_list_view.dart';
import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';
import 'package:nurse/app/theme/app_colors.dart';

class EntityList<T> extends StatelessWidget {
  final String title;
  final String newPage;
  final String buttonText;
  final EntityPageController<T> controller;
  final Widget Function(BuildContext, int) itemBuilder;
  final void Function() onCallback;

  const EntityList({
    Key? key,
    required this.title,
    required this.onCallback,
    required this.newPage,
    required this.buttonText,
    required this.itemBuilder,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NurseAppBar(title: title),
      body: EntityListBuilder<T>(
        title: "$title cadastrada(o)s",
        controller: controller,
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

class EntityListBuilder<T> extends StatelessWidget {
  const EntityListBuilder({
    Key? key,
    required this.controller,
    required this.title,
    required this.itemBuilder,
  }) : super(key: key);

  final String title;
  final EntityPageController<T> controller;
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
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
      ),
    );
  }
}
