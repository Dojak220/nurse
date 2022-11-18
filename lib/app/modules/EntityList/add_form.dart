import 'package:flutter/material.dart';
import 'package:nurse/app/components/save_form_button.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/app/utils/strings_and_styles.dart';
import 'package:nurse/app/utils/try_to_save.dart';

class AddForm extends StatefulWidget {
  final AddFormController controller;
  final String title;
  final Widget formFields;
  final bool isEditing;

  const AddForm(
    this.controller, {
    Key? key,
    required this.title,
    required this.formFields,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  @override
  Widget build(BuildContext context) {
    final double fontSize = adjustFontSize(widget.title);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: fontSize)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.formFields,
            ),
            SaveFormButton(
              onPressed: () => tryToSave(
                widget.controller,
                context: context,
                mounted: mounted,
                entityName: widget.title.toLowerCase(),
                isEditing: widget.isEditing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
