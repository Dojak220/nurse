import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityCategory/priority_category_page_controller.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';

class PriorityCategories extends StatelessWidget {
  final PriorityCategoriesPageController controller;
  const PriorityCategories(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final priorityCategories = controller.entities;

      return EntityList<PriorityCategory>(
        title: "Categorias Prioritárias",
        entities: priorityCategories,
        onCallback: () => controller.getPriorityCategories(),
        newPage: "/priorityCategories/new",
        buttonText: "Nova Categoria Prioritária",
        isLoading: controller.isLoading,
        itemBuilder: (_, index) {
          final priorityCategory = priorityCategories[index];

          return CustomCard(
              title: priorityCategory.name,
              upperTitle: priorityCategory.code,
              startInfo: priorityCategory.description,
              onEditPressed: () => Navigator.of(context)
                  .pushNamed("/priorityCategories/new",
                      arguments: priorityCategory)
                  .whenComplete(
                    () => controller.getPriorityCategories(),
                  ));
        },
      );
    });
  }
}
