import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project2/main_drawer.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HeartRate extends StatefulWidget {
  @override
  _HeartRateState createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  final List<HR> heartList = [];

  Future loadHeartData() async {
    String jsonString = await DefaultAssetBundle.of(context).loadString(
        'resources/heartrate.json'); //pairnw ta json data gia to heartrate
    final jsonDecoded = json.decode(jsonString); //ta kanw decode
    var taggedJson =
        jsonDecoded["activities-heart"]; //apo auta pairnw to activities-heart

    setState(() {
      for (Map x in taggedJson) {
        //mesa sto activities-heart psaxnw gia times sto heartRate kai dateTime kai tis metatrepw

        heartList.add(new HR(
            x["heartRate"].toDouble(),
            x["dateTime"].toString().substring(
                5))); //tis pernaw se ena neo object HR ,to string to koureuw na mhn fainetai to year
      }
    });
  }

  List<charts.Series<HR, String>> _createHRData() {
    //sunarthsh sthn opoia etoimazw to chart me ta data tou heartList
    return [
      charts.Series<HR, String>(
        id: 'HeartRate',
        domainFn: (HR heart, _) => heart.days, //X axis tis meres
        measureFn: (HR heart, _) => heart.bpm, //Y axis ta beats per minute
        data: heartList, //apo dw na parei ta data
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(
            Colors.lightGreen), //xrwma lightgreen
      )
    ];
  }

  @override
  void initState() {
    //gia arxikopoihsh
    super.initState();
    loadHeartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: Text('HeartRate'),
      ),
      drawer: MainDrawer(), // Να έχει drawer
      body: new charts.BarChart(
        //ftiaxnw ena neo Bar chart kai tou pernaw ta data me thn _createHRData()
        _createHRData(),
      ),
    );
  }
}

class HR {
  double bpm;
  String days;
  HR(this.bpm, this.days);
}
