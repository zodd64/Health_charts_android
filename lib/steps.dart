import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project2/main_drawer.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Steps extends StatefulWidget {
  @override
  _StepsState createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  final List<Steps7Days> stepsList = [];
  final List<Steps7Days> calsList = [];

  Future loadStepData() async {
    String jsonString = await DefaultAssetBundle.of(context).loadString(
        'resources/response_calories_steps.json'); //pernaw ta stoixeia tou json
    final jsonDecoded = json.decode(jsonString); //decode
    var taggedJson = jsonDecoded["activities"]; //dialegw ta activities

    setState(() {
      for (Map x in taggedJson) {
        //apo8hkeuw ola ta steps calories kai tis hmeromhnies,se ksexwristes listes gia ksexwrista inputs sto chart
        stepsList.add(new Steps7Days(
            x["steps"].toDouble(),
            (x["startTime"].toString())
                .substring(5, 10))); //deserialization step
        calsList.add(new Steps7Days(x["calories"].toDouble(),
            (x["startTime"].toString()).substring(5, 10)));
      }
    });
  }

  List<charts.Series<Steps7Days, String>> _createStepsData() {
    //sunarthsh sthn opoia etoimazw to chart me ta data tou stepsList kai calsList
    return [
      charts.Series<Steps7Days, String>(
        id: 'Steps',
        domainFn: (Steps7Days steps, _) => steps.days, //X axis tis meres
        measureFn: (Steps7Days steps, _) =>
            steps.stepsCals, //Y axis ta stepsCals
        data: stepsList, //apo dw na parei ta data
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(
            Colors.lightGreen), //xrwma lightgreen
      ),
      charts.Series<Steps7Days, String>(
        id: 'Calories',
        domainFn: (Steps7Days steps, _) => steps.days, //X axis tis meres
        measureFn: (Steps7Days steps, _) =>
            steps.stepsCals, //Y axis ta stepsCals
        data: calsList, //apo dw na parei ta data
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Colors.yellow), //xrwma yellow
      )
    ];
  }

  @override
  void initState() {
    //gia initialization
    super.initState();
    loadStepData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: Text('Steps/Calories'),
      ),
      drawer: MainDrawer(), // Να έχει drawer
      body: new charts.BarChart(
        //ftiaxnw ena neo Bar chart kai tou pernaw ta data me thn _createStepsData()
        _createStepsData(),
        barGroupingType: charts.BarGroupingType.grouped, //grouped
      ),
    );
  }
}

class Steps7Days {
  final double stepsCals; //h gia steps h gia calories analogws
  final String days;
  Steps7Days(this.stepsCals, this.days);
}
