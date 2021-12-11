import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoCodingScreen extends StatefulWidget {
  const GeoCodingScreen({Key? key}) : super(key: key);

  @override
  _GeoCodingScreenState createState() => _GeoCodingScreenState();
}

class _GeoCodingScreenState extends State<GeoCodingScreen> {
  final latitudeController = TextEditingController();
  final longtitudeController = TextEditingController();
  final addressController = TextEditingController();
  late String location = "";
  late String address = "";

  CameraPosition? initialCameraPosition;
  GoogleMapController? googleMapController;

  moveCamera(latitude, longitude) {
    var newPosition = CameraPosition(target: LatLng(latitude, longitude), zoom: 12);

    CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);
    CameraUpdate zoom = CameraUpdate.zoomTo(12);

    googleMapController!.moveCamera(update);
  }

  Future<void> getInitialCameraPos() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true);
    print("${position.latitude}${position.longitude}");
    setState(() {
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 12,
      );
    });
    fetchAddress(position.latitude, position.longitude);
    latitudeController.text = position.latitude.toString();
    longtitudeController.text = position.longitude.toString();
  }

  fetchAddress(latitude, longtitude) async {
    // Imagine that this function is fetching user info from another service or database.
    if (latitude == "" || longtitude == "") {
      setState(() {
        address = "Enter Latitude and Longtitude of Location";
      });
    } else {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longtitude);
      // final data = await locationFromAddress("Gronausestraat 710, Enschede");
      moveCamera(latitude, longtitude);
      Placemark place = placemarks[0];
      setState(() {
        address = place.toString();
      });
      debugPrint('Fetch Location: $place.name`');
    }
  }

  fetchLocation(address) async {
    // Imagine that this function is fetching user info from another service or database.
    // List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longtitude);
    if (address == "") {
      setState(() {
        location = "Enter Address of Location";
      });
    } else {
      List<Location> locations = await locationFromAddress(address);
      if (locations.length > 0) {
        Location place = locations[0];

        setState(() {
          location = place.toString();
        });
        moveCamera(place.latitude, place.longitude);
        debugPrint('Fetch Location: $locations`');
      } else {
        setState(() {
          location = "Cannot find address";
        });
      }
    }
  }

  @override
  void initState() {
    getInitialCameraPos();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    latitudeController.dispose();
    longtitudeController.dispose();
    addressController.dispose();
    googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geocoding"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              initialCameraPosition != null
                  ? Container(
                      height: 400,
                      alignment: Alignment.center,
                      child: GoogleMap(
                        initialCameraPosition: initialCameraPosition!,
                        onMapCreated: (controller) => googleMapController = controller,
                      ),
                    )
                  : Container(
                      child: Text(
                        "Loading Google Map.....",
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Using Location :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: latitudeController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Latitude',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: longtitudeController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Longitude',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  fetchAddress(double.parse(latitudeController.text), double.parse(longtitudeController.text));
                },
                child: const Text(
                  "Get Info",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              ),
              Text(address),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Using Address :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Addresses',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  fetchLocation(addressController.text);
                },
                child: const Text(
                  "Get Location",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              ),
              Text(location),
            ],
          ),
        ),
      ),
    );
  }
}
