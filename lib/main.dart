import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project2/main_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import './heartRate.dart';
import './sleep.dart';
import './steps.dart';
import './demographics.dart';

void main() {
  runApp(MaterialApp(
    title: "Dashboard",
    routes: {
      '/': (context) => MyApp(),
      '/heartRate': (context) => HeartRate(), //route για το hr
      '/steps': (context) => Steps(), //route για τα steps/calories
      '/sleep': (context) => Sleep(), //route για το Sleep
      '/demographics': (context) => Demographics(), //route για το demographics
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final List<double> lineChartList = []; //gia to lineChart tou heartrate
  final List<double> pieChartList = []; //gia to pieChart tou steps/calories

  Future loadHeartData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('resources/heartrate.json'); //fortwnei to heartrate.json
    final jsonDecoded =
        json.decode(jsonString); //decode to jsonString
    var taggedJson = jsonDecoded["activities-heart"]; //sto activities-heart

    setState(() {
      for (Map x in taggedJson) { //gia ka8e heartRate pou 8a vreis mesa sto activities-heart pare to value,kanto double kai perna to sthn lineChartList
        lineChartList.add(x["heartRate"].toDouble()); //deserialization step 3
      }
    });
  }

  Future loadPieData() async { //oti kai to panw alla gia alla gia to arxeio response_calories_steps.json
    String jsonStringHeart = await DefaultAssetBundle.of(context).loadString(
        'resources/response_calories_steps.json'); //load
    final jsonDecodedHeart =
        json.decode(jsonStringHeart); //decode
    var taggedJsonHeart = jsonDecodedHeart["activities"];//sta activities

    setState(() {
      for (Map x in taggedJsonHeart) {
        pieChartList.add(x["steps"].toDouble()); //deserialization step
      }
    });
  }

  @override
  void initState() { //gia arxikopoihsh
    super.initState();
    loadHeartData();
    loadPieData();
  }

  List<CircularStackEntry> _createPieData() { //h sunarthsh auth ousiastika ulopoiei to piechart tou steps/calories kai to epistrefei
    return [
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(pieChartList.last, Colors.lightGreen, rankKey: 'Q1'), //to ena kommati tou pieChart gia ta steps ths teleutaias hmeromhnias sto json
          new CircularSegmentEntry(8000.0-pieChartList.last, Colors.lightGreenAccent, rankKey: 'Q2'), //to allo kommati einai h diafora hmerisiou goal me ta teleutaia steps
        ],
      ),
    ];
  }



  Widget myItems(IconData icon, String heading, Color color, String route) { //widget gia to me kai sleep sto dashboard
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        heading,
                        style: TextStyle(color: color, fontSize: 15.0),
                      ),
                    ),
                    Material(
                      color: Colors.lime[300],
                      borderRadius: BorderRadius.circular(24.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(icon, color: Colors.white, size: 30.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myCircularItems(String title, String route) { //widget gia to piechart
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Colors.grey,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AnimatedCircularChart(
                        //το widget που μας δινει το package flutter_circular_chart.dart
                        size: Size(100.0, 100.0),
                        initialChartData: _createPieData(),
                        chartType: CircularChartType
                            .Pie, //εδω δηλωνουμε τον τυπο του γραφηματος
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //το widgets για να φτιαξουμε το πρωτο γραφημα σε μορφη γραμμης
  Widget myChartItems(String title, String route) { //widget gia to linechart
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Colors.grey,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: new Sparkline(
                          //το γραφημε σε μορφη γραμμης
                          data:
                              lineChartList, // τα double δεδομενα που εχουμε δηλωσει στην αρχη
                          lineColor: Colors.blueGrey,
                          pointsMode: PointsMode
                              .all, //δειχνει τα σημεια με τις τιμες σαν βουλες/points
                          pointSize: 8.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        drawer: MainDrawer(),
        body: StaggeredGridView.count(
          crossAxisCount:
              2, //ο αριθμος των στηλων που θελουμε να καλυπτει το grid
          crossAxisSpacing:
              12.0, //η αποσταση μεταξυ των κουτιων στον οριζοντιο αξονα
          mainAxisSpacing:
              12.0, //η αποσταση μεταξυ των κουτιων στον καθετο αξονα
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            myChartItems("HeartRate", "/heartRate"),
            myCircularItems("Steps", "/steps"),
            myItems(Icons.account_box_rounded, "Me", Colors.lightGreen,
                "/demographics"),
            myItems(Icons.bedtime, "Sleep", Colors.lightGreen, "/sleep"),
          ],
          staggeredTiles: [
            //οσα αντικειμενα βαλαμε στο children τοσα πρεπει να βαλουμε και εδω
            StaggeredTile.extent(2,
                220.0), //η πρωτη παραμετρος λεει ποσες στηλες να καλυπτει το tile/κουτι
            StaggeredTile.extent(
                1, 250.0), //δευτερη παραμετρος λεει το υψος τους tile/κουτιου
            StaggeredTile.extent(1, 120.0),
            StaggeredTile.extent(1, 120.0),
          ],
        ));
  }
}


