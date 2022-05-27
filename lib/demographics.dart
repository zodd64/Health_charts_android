import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project2/main_drawer.dart';

class Demographics extends StatefulWidget {
  @override
  _DemographicsState createState() => _DemographicsState();
}

class _DemographicsState extends State<Demographics> {
  var avatar;
  var displayName;
  var dateOfBirth;

  Future loadDemoData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('resources/profile.json'); //pernw to profile.json
    final jsonDecoded = json.decode(jsonString); //decode
    var taggedJson = jsonDecoded["user"]; //pairnw to user

    setState(() {
      //pernaw ta parakatw se metavlhtes
      avatar = taggedJson["avatar"].toString();
      displayName = taggedJson["displayName"].toString();
      dateOfBirth = taggedJson["dateOfBirth"].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    loadDemoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        //Εδώ δίνω χρώμα στο appBar του demographics
        title: Text('Demographics'),
      ),
      drawer: MainDrawer(), // Να έχει drawer
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            //kentrarisma ston aksona Y
            crossAxisAlignment: CrossAxisAlignment.center,
            //kentrarisma ston aksona X
            children: [
              Image.network(avatar), //gia na emfanisei to avatar
              Text(displayName), //to onoma
              Text(dateOfBirth), //thn dob
            ]),
      ),
    );
  }
}
