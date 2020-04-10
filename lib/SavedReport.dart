import 'dart:convert';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Person{
  String name;
  int age;
  String address;
  LatLng coordinates;
  int condition;
  bool certainty;

  bool isFinished = false;

  Person();

  void setName(String name){
    if(!isFinished){
      this.name = name;
    }
  }
  void setAge(int age){
    if(!isFinished){
      this.age = age;
    }
  }
  void setAddress(String address){
    if(!isFinished){
      this.address = address;
    }
  }
  void setCoordinates(LatLng coordinates){
    this.coordinates = coordinates;
  }
  void setCondition(int condition){
    if(!isFinished){
      this.condition = condition;
    }
  }
  void setCertainty(bool isCertain){
    if(!isFinished){
      this.certainty = isCertain;
    }
  }

  void submit(){
    // this.isFinished = true;
    print("***************$this");
  }

  String getName(){
    return name;
  }
  int getAge(){
    return age;
  }
  String getAddress(){
    return address;
  }
  Future<LatLng> getCoordinates() async{
    if(this.coordinates == null){
      GeoCoder temp = new GeoCoder(this.address);
      return temp.getLocation();
    }
    return this.coordinates;
  }
  int getCondition() {
    return condition;
  }
  bool getCertainty(){
    return certainty;
  }

  String toString(){
    return "\n\n\n\n\n\n\n\n\nName: $name age: $age address: $address location: $coordinates Severity: $condition Certain: $certainty\n\n\n\n\n\n\n\n\n";
  }
}


class GeoCoder{
  String address;
  LatLng location;

  static const String _API_KEY = 'AIzaSyDKt2DFNf1QwKSOz4LsskeOyl4GaX6xP3c';
  static final String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=';

  var data;

  GeoCoder(String address) {
    this.address = address;
    setLocation(address);
  }

  Future<LatLng> setLocation(String address) async{
    try{
      var temp = await findLocation(address);
      this.location = temp;
    }catch (err){
      print("Caught Error:$err");
    }
    return this.location;
  }

  Future<LatLng> getLocation() async{
    if(this.location == null) return setLocation(address);
    return this.location;
  }

  Future<LatLng> findLocation(String address) async{
    var temp = [];
    if(address != null)
      temp = address.split(" ");

    String formattedAddress = "";

    for(String word in temp){
      formattedAddress += word + "+";
    }
    formattedAddress = formattedAddress.substring(0,formattedAddress.length-1);

    String url = baseUrl+ formattedAddress + '&key=' + _API_KEY;

    final response = await http.get(url);

    if (response.statusCode == 200) {
          data = jsonDecode(response.body);
    } else {
        throw Exception('An error occurred getting location');
    }
    print(data);

      
    return organizeData();
  }

  LatLng organizeData(){
    List<Map<String, dynamic>> results = [];

    if (data == null) {
      return new LatLng(0,0);
    }

    results = new List();

    for (Map<String, dynamic> result in data['results']) {
      results.add(result);
    }

    var primaryResult = results[0];

    return new LatLng(
      primaryResult["geometry"]["location"]["lat"],
      primaryResult["geometry"]["location"]["lng"],
      );

  }
}