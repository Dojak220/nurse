import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/patient/priority_category_page_controller.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:provider/provider.dart';

class PriorityCategories extends StatelessWidget {
  const PriorityCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PriorityCategoriesPageController>(context);
    final priorityCategories = controller.entities;

    return EntityList<PriorityCategory>(
      title: "Categorias Prioritárias",
      controller: controller,
      onCallback: () => context
          .read<PriorityCategoriesPageController>()
          .getPriorityCategories(),
      newPage: "/priorityCategories/new",
      buttonText: "Nova Categoria Prioritária",
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
                  () => context
                      .read<PriorityCategoriesPageController>()
                      .getPriorityCategories(),
                ));
      },
    );
  }
}
