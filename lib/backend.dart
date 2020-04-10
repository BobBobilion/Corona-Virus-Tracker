import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class Report {
  String name;
  int age;
  String address;
  double lat;
  double lon;
  int condition;
  bool certainty;

  Report(this.name, this.age, this.address, this.lat, this.lon, this.condition, this.certainty);

  Report.fromJson(Map<String, dynamic> json) :
        name = json['name'],
        age = json['age'],
        address = json['address'],
        lat = json['lat'] + 0.0,
        lon = json['lon'] + 0.0,
        condition = json['condition'] + 0.0,
        certainty = json['certainty'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'age' : age,
    'address' : address,
    'lat': lat,
    'lon': lon,
    'condition' : condition,
    'certainty' : certainty,
  };
  
  @override
  String toString() {
    return jsonEncode(this);
  }
}

Future<void> reportCase(Report report) async {
  await FirebaseDatabase.instance.reference().child('reports').push().set(report.toJson());
}

Stream getNearbyReports(){
  return FirebaseDatabase.instance.reference()
      .child('reports')
      .onValue
      .map(
          (event) {
            List<Report> reports = [];

            dynamic value = event.snapshot.value;

            for (String key in value.keys) {
              Map<String, dynamic> map = {};

              for (String innerKey in value[key].keys) {
                map[innerKey] = value[key][innerKey];
              }

              reports.add(Report.fromJson(map));
            }

            return reports;
          }
      );
}