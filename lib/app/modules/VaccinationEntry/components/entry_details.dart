import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';

class VaccinationEntryDetails extends StatelessWidget {
  const VaccinationEntryDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key("vaccination_details"),
      child: Column(
        children: [
          Text("Cadastro sendo realizado"),
          Container(
            color: AppColors.cinzaClaro,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 20, 15.0, 20),
              child: Container(
                color: AppColors.white,
                child: Column(
                  children: [
                    Text("Um Dois Três de Oliveira Quatro"),
                    Container(
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 0,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Cadastro SUS"),
                              Text("123456789"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("CPF"),
                              Text("123.456.789-00"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Idade"),
                              Text("42 anos"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Grupo"),
                              Text("Gestante"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Vacina"),
                              Text("Coronavac"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Dose"),
                              Text("1ª dose"),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
