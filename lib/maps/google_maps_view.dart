import 'package:flightflutter/maps/google_maps_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flightflutter/maps/flight_map_model.dart';
// class GoogleMapsView extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     TODO: implement createState
//     throw UnimplementedError();
//   }
//   @override
//   _GoogleMapsViewState createState() => _GoogleMapsViewState();
// }



class GoogleMapsView extends GoogleMapsViewModel {

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      //bearing: 192.8334901395799,
      target: LatLng(40.9130116, 29.2094771),
      //tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      //floatingActionButton: buildFloatingActionButton(),
      body: Stack(
        children: [
          buildGoogleMap,
          bottomListView,
          
        ],
      ), 
    );
  }

  @override
  void initState() { 
    super.initState();
    Future.microtask(() => initMapItemList()
    );
  }

  Widget get bottomListView => Positioned(
            height: 100,
            //width: MediaQuery.of(context).size.width,
            bottom: 20,
            left: 20,
            right: 5,
            child: flightList.isEmpty ? loadingWidget : listViewFlights(),
          );

  Widget get loadingWidget => Center (
    child: CircularProgressIndicator(),
  );

  ListView listViewFlights() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
            itemCount: flightList.length,
            itemBuilder: (context, index){
            return SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Card(
                child: ListTile(
                  onTap: () => controller.animateCamera(CameraUpdate.newLatLng(flightList[index].latlong)),
                  
                  title: Text(flightList[index].country),
                ),
              ),
            );
          });
  }

  Widget get buildGoogleMap => GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kLake,
      onMapCreated: (map) async {
        await _createMarkerImageFromAsset(context);
        controller = map;
      },
      markers: _createrMarker(),
    );
  

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){
        controller.animateCamera(CameraUpdate.newLatLng(LatLng(40.9906621, 29.0200943)));
      },
    );
  }

  

  BitmapDescriptor dogIcon;

}

extension GoogleMapsViewMarkers on GoogleMapsView{
  Set<Marker> _createrMarker(){

    return flightList.map((e) => Marker(
      
        markerId: MarkerId(e.hashCode.toString()),
        position: e.latlong,
        icon:dogIcon, //BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        zIndex: 10,
        infoWindow: InfoWindow(
          title: e.country,
        ),
      ),).toSet();
  }

  

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if(dogIcon == null){
      final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context);
      var bitmap = await BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/images/dog.png");
      dogIcon = bitmap;
      setState(() {
        
      });
    }
      
      
  }

}