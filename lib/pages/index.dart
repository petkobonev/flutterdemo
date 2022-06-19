import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  List flights = List.empty();
  List filteredFlights = List.empty();
  bool _isSuccess = false;

  void toggle() {
    // setState(() => _isSuccess = !_isSuccess);
    successFlight();
  }

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  fetchFlights() async {
    var uri = Uri.parse("https://api.spacexdata.com/v4/launches/");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var flights = json.decode(response.body);
      setState(() {
        this.flights = flights;
        filteredFlights = flights;
      });
    } else {
      flights = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SpaceX List"), actions: [
        Switch(
            value: _isSuccess,
            activeColor: Colors.black,
            activeThumbImage: new NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlZ0YAZvi8TO4yjRyH8qsXyRC0VFPKsbbphQ&usqp=CAU'),
            inactiveThumbImage: new NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREDp7SVi65K6IprmINoDSUpubMPCQSvvhhSA&usqp=CAU'),
            onChanged: (val) {
              toggle();
            }),
      ]),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView.builder(
        itemCount: filteredFlights.length,
        itemBuilder: (context, index) => getCard(filteredFlights[index]));
  }

  void successFlight() {
    final results = _isSuccess
        ? flights.where((element) {
            return element['success'] == true;
          }).toList()
        : flights;

    setState(() {
      filteredFlights = results;
    });
  }

  Widget getCard(flights) {
    var name = flights['name'];
    var success = flights['success'];
    var image = flights['links']['patch']['small'];

    return Card(
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 125, 122, 1),
                  image: DecorationImage(image: NetworkImage(image))),
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                SizedBox(
                  height: 10,
                ),
                Text("Status: $success"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
