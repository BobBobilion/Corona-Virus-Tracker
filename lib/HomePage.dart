import 'package:coronavirus_tracker/Report.dart';
import 'package:coronavirus_tracker/SavedReport.dart';
import 'package:coronavirus_tracker/backend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'InfoPage.dart';

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // // This widget is the home page of your application. It is stateful, meaning
  // // that it has a State object (defined below) that contains fields that affect
  // // how it looks.

  // // This class is the configuration for the state. It holds the values (in this
  // // case the title) provided by the parent (in this case the App widget) and
  // // used by the build method of the State. Fields in a Widget subclass are
  // // always marked "final".

  // final String title;


  _MyHomePageState homePage = new _MyHomePageState();

  @override
  _MyHomePageState createState() => homePage;

  MyHomePage(Person person){
    createState();
    if(person != null)
      homePage.addTracker(person);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;
  static const LatLng _center = const LatLng(3.6191515, -117.8228972);

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  MapType currentMapType = MapType.normal;
 
  LatLng currentCameraPosition = _center;

   void setHome() {
    var devicePosition = Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.best)
    .then((data) {
      setCameraPosition(data.latitude, data.longitude);
      currentCameraPosition = LatLng(data.latitude,data.longitude);
      });
  }

  void setCurrentCameraPosition(CameraPosition position){
    currentCameraPosition = position.target;
  }
  void setCameraPosition(double lat, double long) {
    mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
  }

  void changeMapType(){
    setState(() {
      if(currentMapType == MapType.normal){
        currentMapType = MapType.satellite;
      }else{
        currentMapType = MapType.normal;
      }
    });
      
  }

  void createCircle(LatLng location){
    circles.add(Circle(
      circleId: CircleId(location.toString()),
      radius: 100,
      center: location,
      fillColor: Color.fromARGB(100, 255, 0, 0),
      strokeWidth: 0,
    ));
  }

  void createMarker(LatLng location, String name, int severity){
    markers.add(Marker(
      markerId: MarkerId(location.toString()),
      position: location,
      infoWindow: InfoWindow(
        title: name,
        snippet: "Severity (1-10): $severity",
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      setHome();
    });
  }

  void addTracker(Person person){
    var coordinates = person.getCoordinates()
                              .then((data){
                                print(data);
                                createMarker(data, person.name, person.condition);
                                createCircle(data);
                                person.setCoordinates(data);
                              });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType : currentMapType,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: currentCameraPosition,
                zoom: 15.0,
              ),
              onCameraMove: setCurrentCameraPosition,
              markers: markers,
              circles: circles,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: changeMapType,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                      heroTag: null,
                    ),
                    FloatingActionButton(
                      onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WebViewExample()),
                      );
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.info_outline, size: 36.0),
                      heroTag: null,
                    ),
                    FloatingActionButton(
                      onPressed: () { 
                        ReportPage report = new ReportPage();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => report),
                        );
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.add, size: 36.0),
                      heroTag: null,
                    ),
                    FloatingActionButton(
                      heroTag: null,
                      onPressed: () {setState(() {});},
                      child: const Icon(Icons.refresh, size: 36.0),
                    ),
                  ],
                ), 
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    getNearbyReports().listen((data) {
      print("--------------------");
      print(data);
      if (data != null && data.length > 0) {
        setState(() {
          markers = Set.from([]);
          circles = Set.from([]);
          int counter = 0;
          for (Report report in data) {
            counter++;
            circles.add(
              Circle(
                strokeColor: Colors.red[200].withOpacity(1),
                fillColor: Colors.red[200].withOpacity(0.6),
                circleId: CircleId(counter.toString()),
                center: LatLng(report.lat, report.lon),
                radius: 100,
              )
            );
            markers.add(
              Marker(
                markerId: MarkerId(counter.toString()),
                position: LatLng(report.lat, report.lon),
                infoWindow: InfoWindow(
                  title: report.name,
                  snippet: "Severity (1-10): "+report.condition.toString(),
                ),
                icon: BitmapDescriptor.defaultMarker,
              )
            );
          }
        });
      }
    });

  }
}
