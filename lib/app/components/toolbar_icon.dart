import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';

class ToolbarIcon extends StatelessWidget {
  const ToolbarIcon(
    this.iconPosition, {
    Key? key,
    required this.icon,
    required this.label,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  final int selectedIndex;
  final int iconPosition;
  final IconData icon;
  final String label;
  final void Function(int p1) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: selectedIndex == iconPosition
              ? const BorderSide(color: AppColors.verdeEscuro, width: 3)
              : BorderSide.none,
        ),
      ),
      child: IconButton(
        tooltip: label,
        iconSize: 35,
        onPressed: () => onItemTapped(iconPosition),
        icon: Icon(
          icon,
          color: selectedIndex == iconPosition ? AppColors.verdeEscuro : null,
        ),
      ),
    );
  }
}
