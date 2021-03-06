import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../model/bottomSheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../provider/parkingLotProvider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Modal modal = new Modal();
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = <Marker>[];

  LocationData currentLocation;

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goMyLoc() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 18,
    )));
  }

  void getParkingData() {
    final parkingLots = Provider.of<ParkingLotProvider>(context);
    final lots = parkingLots.parkingLots;
    for (int i = 0; i < parkingLots.parkingLotsCount; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(lots[i].id),
          position: LatLng(
            double.parse(lots[i].lat),
            double.parse(lots[i].lon),
          ),
          infoWindow: InfoWindow(
            title: lots[i].title,
            snippet: '${lots[i].title} คณะวิศวกรรมศาสตร์',
          ),
          onTap: () => modal.mainBottomSheet(context, lots[i].id),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getParkingData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('C-Parking'),
        ),
        drawer: AppDrawer(),
        // drawer: AppDrawer(),
        body: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              markers: Set.from(markers),
              // Marker(
              //   onTap: () => modal.mainBottomSheet(context, "30#1"),
              //   markerId: MarkerId("1"),
              //   position: LatLng(18.795484, 98.952698),
              //   infoWindow: InfoWindow(
              //       title: "ตึกสามสิบปี#1",
              //       snippet: "ตึกสามสิบปี#1 คณะวิศวกรรมศาสตร์"),
              // ),
              // Marker(
              //   onTap: () => modal.mainBottomSheet(context, "30#2"),
              //   markerId: MarkerId("2"),
              //   position: LatLng(18.795353, 98.952700),
              //   infoWindow: InfoWindow(
              //       title: "ตึกสามสิบปี#2",
              //       snippet: "ตึกสามสิบปี#2 คณะวิศวกรรมศาสตร์"),
              // ),
              // Marker(
              //   onTap: () => modal.mainBottomSheet(context, "SUR#1"),
              //   markerId: MarkerId("3"),
              //   position: LatLng(18.795051, 98.952685),
              //   infoWindow: InfoWindow(
              //       title: "ตึกเซอร์เวย์#1",
              //       snippet: "ตึกเซอร์เวย์#1 คณะวิศวกรรมศาสตร์"),
              // ),
              // Marker(
              //   onTap: () => modal.mainBottomSheet(context, "SUR#2"),
              //   markerId: MarkerId("4"),
              //   position: LatLng(18.795033, 98.952969),
              //   infoWindow: InfoWindow(
              //       title: "ตึกเซอร์เวย์#2",
              //       snippet: "ตึกเซอร์เวย์#2 คณะวิศวกรรมศาสตร์"),
              // )
              // ..._markers
              // myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(18.795484, 98.952698),
                zoom: 18,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                child: Icon(Icons.place),
                onPressed: _goMyLoc,
              ),
            )
          ],
        ));
  }
}
