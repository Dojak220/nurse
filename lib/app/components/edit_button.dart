import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    Key? key,
    required this.onEditPressed,
  }) : super(key: key);

  final void Function() onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: const BoxDecoration(
        color: AppColors.verdeClaro,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: IconButton(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(top: 4.0, right: 4.0),
        icon: const Icon(
          Icons.edit,
          color: AppColors.verdeEscuro,
          size: 18.0,
        ),
        onPressed: () => onEditPressed,
      ),
    );
  }
}
