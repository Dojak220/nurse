import 'package:flutter/material.dart';
import 'package:nurse/app/components/nurse_appbar.dart';
import 'package:nurse/app/components/registration_button.dart';
import 'package:nurse/app/components/titled_list_view.dart';
import 'package:nurse/app/theme/app_colors.dart';

class EntityList<T> extends StatelessWidget {
  final String title;
  final String newPage;
  final String buttonText;
  final List<T> entities;
  final Widget Function(BuildContext, int) itemBuilder;
  final bool isLoading;
  final void Function() onCallback;

  const EntityList({
    Key? key,
    required this.title,
    required this.onCallback,
    required this.newPage,
    required this.buttonText,
    required this.entities,
    required this.itemBuilder,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NurseAppBar(title: title),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : EntityListBuilder<T>(
              title: "$title cadastrada(o)s",
              entities: entities.toList(),
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
    required this.title,
    required this.itemBuilder,
    required this.entities,
  }) : super(key: key);

  final String title;
  final List<T> entities;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TitledListView(
        title,
        itemCount: entities.length,
        itemBuilder: itemBuilder,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
    );
  }
}
