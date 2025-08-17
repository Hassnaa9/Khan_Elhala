import 'package:bazario/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import the geolocator package

class LocationAccessScreen extends StatefulWidget {
  const LocationAccessScreen({super.key});

  @override
  State<LocationAccessScreen> createState() => _LocationAccessScreenState();
}

class _LocationAccessScreenState extends State<LocationAccessScreen> {
  // Function to request location permissions
  Future<void> _requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle this case
      // e.g., show a dialog to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for existing permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle this case
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, direct user to app settings
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied. Please enable them in app settings.'),
        ),
      );
      // You can also add logic to open the app settings
      await Geolocator.openAppSettings();
      return;
    }

    // Permissions are granted, you can now get the user's location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Use the position data as needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location granted! Latitude: ${position.latitude}, Longitude: ${position.longitude}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Replace this with the button you want to use
    return Center(
        child: TextButton(
          onPressed: _requestLocationPermission, // Call the permission function
          style: TextButton.styleFrom(
            backgroundColor: MyColors.kPrimaryColor, // Use your color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.85,
              50,
            ),
            padding: EdgeInsets.zero,
          ),
          child: const Text(
            "Allow Location Access",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
    );
  }
}