import "package:flutter/material.dart";
import "package:nurse/app/theme/app_colors.dart";

class VaccinationButton extends StatelessWidget {
  final String newPage;
  final void Function() onCallback;

  const VaccinationButton({
    Key? key,
    required this.newPage,
    required this.onCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 18, 10, 0),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: AppColors.verdeEscuro,
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.vaccines_rounded,
          color: AppColors.white,
          size: 40,
        ),
        onPressed: () async => Navigator.of(context)
            .pushNamed(newPage)
            .whenComplete(() => onCallback()),
      ),
    );
  }
}
