import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';

class DateField extends StatelessWidget {
  final String label;
  final String? value;
  final void Function()? onTap;
  const DateField({
    Key? key,
    required this.label,
    this.onTap,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.verdeEscuro,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              onTap: onTap,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "dd/mm/aaaa",
                label: Text(label),
                hintStyle: AppTheme.defaultTextStyle,
              ),
              controller: TextEditingController(text: value),
              readOnly: true,
            ),
          ),
          IconButton(
            onPressed: onTap,
            alignment: Alignment.bottomRight,
            icon: const Icon(Icons.calendar_today_rounded),
          ),
        ],
      ),
    );
  }
}
