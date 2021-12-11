import 'package:flutter/material.dart';
import 'package:google_map_demo/current_location_screen.dart';
import 'package:google_map_demo/geocoding_screen.dart';
import 'package:google_map_demo/location_tracking_screen.dart';
import 'package:google_map_demo/map_screen.dart';
import 'package:google_map_demo/placesapi_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      color: Colors.white,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      print('Turn on location services before requesting permission.');
      return;
    }
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map demo"),
      ),
      body: Column(
        children: [
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CurrentLocationScreen(),
              ),
            ),
            child: const Text("Current location"),
          ),
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MapScreen(),
              ),
            ),
            child: const Text("Map screen"),
          ),
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GeoCodingScreen(),
              ),
            ),
            child: const Text("Geocoding"),
          ),
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlacesApiScreen(),
              ),
            ),
            child: const Text("PlacesApi"),
          ),
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LocationTrackingScreen(),
              ),
            ),
            child: const Text("Location tracking screen"),
          )
        ],
      ),
    );
  }
}
