import 'package:flutter/material.dart';

class VaccinationForm extends StatefulWidget {
  const VaccinationForm({
    Key? key,
  }) : super(key: key);

  @override
  State<VaccinationForm> createState() => _VaccinationFormState();
}

class _VaccinationFormState extends State<VaccinationForm> {
  var _formIndex = 0;
  FocusNode _cnsFocusNode = FocusNode();
  FocusNode _cpfFocusNode = FocusNode();
  FocusNode _ageFocusNode = FocusNode();
  FocusNode _groupFocusNode = FocusNode();
  FocusNode _vaccineFocusNode = FocusNode();
  FocusNode _doseFocusNode = FocusNode();

  var _cns = '';
  var _cpf = '';
  var _age = '';
  var _group = '';
  var _vaccine = '';
  var _dose = '';

  var _invalidMessage = "";

  @override
  void dispose() {
    _cnsFocusNode.dispose();
    _cpfFocusNode.dispose();
    _ageFocusNode.dispose();
    _groupFocusNode.dispose();
    _vaccineFocusNode.dispose();
    _doseFocusNode.dispose();

    super.dispose();
  }

  void _switchInputField(int newIndex) {
    setState(() {
      _formIndex = newIndex;
    });
    switch (newIndex) {
      case 0:
        FocusScope.of(context).requestFocus(_cnsFocusNode);
        break;
      case 1:
        FocusScope.of(context).requestFocus(_cpfFocusNode);
        break;
      case 2:
        FocusScope.of(context).requestFocus(_ageFocusNode);
        break;
      case 3:
        FocusScope.of(context).requestFocus(_groupFocusNode);
        break;
      case 4:
        FocusScope.of(context).requestFocus(_vaccineFocusNode);
        break;
      case 5:
        FocusScope.of(context).requestFocus(_doseFocusNode);
        break;
      default:
        FocusScope.of(context).requestFocus(_cnsFocusNode);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      key: Key("vaccination_form"),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            IndexedStack(
              index: _formIndex,
              children: [
                TextField(
                  key: Key("vaccination_form_cns"),
                  focusNode: _cnsFocusNode,
                  decoration: InputDecoration(
                    labelText: "CNS",
                  ),
                  onSubmitted: (value) {
                    _switchInputField(_formIndex + 1);
                  },
                  onChanged: (value) {
                    setState(() {
                      _cns = value;
                    });
                  },
                ),
                TextField(
                  key: Key("vaccination_form_cpf"),
                  focusNode: _cpfFocusNode,
                  decoration: InputDecoration(
                    labelText: "CPF",
                  ),
                  onSubmitted: (value) {
                    _switchInputField(_formIndex + 1);
                  },
                  onChanged: (value) {
                    setState(() {
                      _cpf = value;
                    });
                  },
                ),
                TextField(
                  key: Key("vaccination_form_age"),
                  focusNode: _ageFocusNode,
                  decoration: InputDecoration(
                    labelText: "Idade",
                  ),
                  onSubmitted: (value) {
                    _switchInputField(_formIndex + 1);
                  },
                  onChanged: (value) {
                    setState(() {
                      _age = value;
                    });
                  },
                ),
                TextField(
                  key: Key("vaccination_form_group"),
                  focusNode: _groupFocusNode,
                  decoration: InputDecoration(
                    labelText: "Grupo",
                  ),
                  onSubmitted: (value) {
                    _switchInputField(_formIndex + 1);
                  },
                  onChanged: (value) {
                    setState(() {
                      _group = value;
                    });
                  },
                ),
                TextField(
                  key: Key("vaccination_form_vaccine"),
                  focusNode: _vaccineFocusNode,
                  decoration: InputDecoration(
                    labelText: "Vacina",
                  ),
                  onSubmitted: (value) {
                    _switchInputField(_formIndex + 1);
                  },
                  onChanged: (value) {
                    setState(() {
                      _vaccine = value;
                    });
                  },
                ),
                TextField(
                  key: Key("vaccination_form_dose"),
                  focusNode: _doseFocusNode,
                  decoration: InputDecoration(
                    labelText: "Dose",
                  ),
                  onSubmitted: (value) {
                    _switchInputField(_formIndex + 1);
                  },
                  onChanged: (value) {
                    setState(() {
                      _dose = value;
                    });
                  },
                ),
              ],
            ),
            Container(child: errorMessage()),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    child: Text("Anterior"),
                    onPressed: () => _switchInputField(_formIndex - 1),
                  ),
                  OutlinedButton(
                    child: Text("Próximo"),
                    onPressed: () => _switchInputField(_formIndex + 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget errorMessage() {
    switch (_formIndex) {
      case 0:
        return Text(_invalidMessage);
      case 1:
        return Text(_invalidMessage);
      case 2:
        return Text(_invalidMessage);
      case 3:
        return Text(_invalidMessage);
      case 4:
        return Text(_invalidMessage);
      case 5:
        return Text(_invalidMessage);
      default:
        return Text(_invalidMessage);
    }
  }
}
