import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';

class CustomDropdownButtonFormField<T> extends CustomFormField {
  final List<T> items;
  final void Function(T?)? onChanged;
  final bool isEnum;

  CustomDropdownButtonFormField({
    Key? key,
    required Icon icon,
    required FormLabels label,
    required this.items,
    this.isEnum = false,
    required this.onChanged,
  }) : super(icon: icon, hint: label.hint, description: label.description);

  List<T> _sortItemsAlphabetically() {
    final sortedList = List.of(items);

    sortedList.sort((a, b) {
      return a.toString().toLowerCase().compareTo(b.toString().toLowerCase());
    });

    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    final sortedItems = _sortItemsAlphabetically();

    return DropdownButtonFormField(
      decoration: InputDecoration(
        icon: icon,
        border: border,
        hintText: hint,
        labelText: description,
      ),
      isExpanded: true,
      value: sortedItems.length == 1 ? sortedItems.first : null,
      items: sortedItems
          .map((item) => DropdownMenuItem(
              value: item,
              child: Text(isEnum ? (item as Enum).name : item.toString())))
          .toList(),
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
