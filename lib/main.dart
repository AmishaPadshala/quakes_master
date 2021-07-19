import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _quakes;
List _features;

void main() async {
  _quakes = await getQuakes();

  _features = _quakes['features'];

  runApp(MaterialApp(
    title: "Quakes",
    home: Quakes(),
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _features.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, int position) {
            // Creating rows for the Listview
            if (position.isOdd) {
              return Divider();
            }

            final index = position ~/ 2;

            var date = DateTime.fromMicrosecondsSinceEpoch(
                _features[index]['properties']['time'] * 1000,
                isUtc: true);
            var format = DateFormat.yMMMMd("en_US").add_jm();
            var dateString = format.format(date);

            return ListTile(
              title: Text(
                "At: $dateString",
                style: TextStyle(
                  fontSize: 15.5,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                "${_features[index]['properties']['place']}",
                style: TextStyle(
                  fontSize: 14.5,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  "${_features[index]['properties']['mag']}",
                  style: TextStyle(
                    fontSize: 15.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              onTap: () {
                _showAlertMessage(
                    context, "${_features[index]['properties']['title']}");
              },
            );
          },
        ),
      ),
    );
  }

  void _showAlertMessage(BuildContext context, String s) {
    var alert = AlertDialog(
      title: Text('Quakes'),
      content: Text(s),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        )
      ],
    );
    showDialog(context: context, child: alert);
  }
}

Future<Map> getQuakes() async {
  String apiURL =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

  http.Response response = await http.get(apiURL);
  return json.decode(response.body);
}
