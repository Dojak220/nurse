import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/app/utils/enum_to_name.dart';
import 'package:nurse/app/utils/form_labels.dart';

class CustomDropdownButtonFormField<T> extends CustomFormField {
  final List<T> items;
  final T? value;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final bool isEnum;

  CustomDropdownButtonFormField({
    Key? key,
    required Icon icon,
    required FormLabels label,
    required this.items,
    this.value,
    this.isEnum = false,
    required this.onChanged,
    this.onSaved,
  }) : super(
          key: key,
          icon: icon,
          hint: label.hint,
          description: label.description,
        );

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

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          icon: icon,
          border: border,
          hintText: hint,
          labelText: description,
        ),
        selectedItemBuilder: isEnum
            ? (_) => sortedItems
                .map((T item) => Text(enumToName(item as Enum)))
                .toList()
            : null,
        isExpanded: true,
        value: value ?? (sortedItems.length == 1 ? sortedItems.first : null),
        items: sortedItems
            .map((item) => DropdownMenuItem(
                value: item,
                child:
                    Text(isEnum ? enumToName(item as Enum) : item.toString())))
            .toList(),
        onChanged: onChanged,
        onSaved: onSaved,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
