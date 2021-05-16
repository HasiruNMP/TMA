import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class BusMap extends StatefulWidget {

  @override
  _BusMapState createState() => _BusMapState();
}

class _BusMapState extends State<BusMap> {

  BitmapDescriptor busicon;

  @override
  void initState() {
    super.initState();
    setMapMarker();
  }

  GoogleMapController mapController;
  static const _initialPosition = LatLng(7.2906, 80.6337);
  LatLng _lastPostion = _initialPosition;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wait For Your Bus"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      //backgroundColor: Colors.red,
      body: Container(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: LatLng(6.844688, 80.015283), zoom: 15.0,),
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
          onCameraMove: _onCameraMove,
          markers: _markers,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    showBusLocation();
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPostion = position.target;
    });
  }

  void showBusLocation() async {

    setState(() {

      FirebaseFirestore.instance.collection('buses').doc('GE-3412').snapshots().listen((DocumentSnapshot busLocation) {

        print("location updated");

        _markers.add(Marker(markerId: MarkerId('bus'), position: LatLng(6.844610383055133, 80.014490977822), icon: busicon));

        mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(6.844610383055133, 80.014490977822)));

      });
    });
  }

  void setMapMarker() async{
    busicon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(60,60)), 'assets/bus.png');
  }

}