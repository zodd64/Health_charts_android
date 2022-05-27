import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project2/main_drawer.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Sleep extends StatefulWidget {
  @override
  _SleepState createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  final List<Sleep7Days> sleepList = [];

  Future loadSleepData() async {
    String jsonString = await DefaultAssetBundle.of(context).loadString(
        'resources/sleep7days.json'); //pairnw ta json data gia ton upno
    final jsonDecoded = json.decode(jsonString); //ta kanw decode
    var taggedJson = jsonDecoded["sleep"]; //apo auta dialegw to sleep
    var y = 1; //metavlhth gia tis meres apo 1-7
    setState(() {
      for (Map x in taggedJson) {
        sleepList.add(new Sleep7Days((x["duration"].toDouble() / 60000),
            y++)); //dhmiourgw neo object Sleep7days kai tou pernaw thn diarkeia se lepta kai to y
      }
    });
  }

  List<charts.Series<Sleep7Days, int>> _createSleepData() {
    //sunarthsh sthn opoia etoimazw to chart me ta data tou sleepList
    return [
      charts.Series<Sleep7Days, int>(
        id: 'Sleep',
        domainFn: (Sleep7Days sleep, _) => sleep.days,
        measureFn: (Sleep7Days sleep, _) => sleep.minutes,
        data: sleepList,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(
            Colors.lightGreen), //naxei to chart lightGreen xrwma
      )
    ];
  }

  @override
  void initState() {
    //gia na arxikopoihsei ta parakatw
    super.initState();
    loadSleepData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: Text('Sleep'),
      ),
      drawer: MainDrawer(), // Να έχει drawer
      body: new charts.LineChart(
        //ftiaxnw ena neo Line chart kai tou pernaw ta data me thn _createSleepData()
        _createSleepData(),
        defaultRenderer: new charts.LineRendererConfig(
            includeArea: true,
            stacked: true), //gia na exei xrwma kai katw apto line
      ),
    );
  }
}

class Sleep7Days {
  final double minutes;
  final int days;
  Sleep7Days(this.minutes, this.days);
}
