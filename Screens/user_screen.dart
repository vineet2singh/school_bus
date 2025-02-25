import 'package:assign_project/Screens/bus_driver_profile_screen.dart';
import 'package:assign_project/Screens/map_screen.dart';
import 'package:assign_project/Screens/school_trip_screen.dart';
import 'package:assign_project/utils/app_constants.dart';

import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(AppConstants.driverName),
            accountEmail: Text("School Bus Assistant"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/bus_driver.jpeg'), // Replace with your image asset
            ),
            decoration: BoxDecoration(color: Color(0xFF4B268F)),
          ),
          ListTile(
            leading: Icon(Icons.map, color: Color(0xFF4B268F)),
            title: Text("MAP"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(),));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Color(0xFF4B268F)),
            title: Text("NOTIFICATIONS"),
            trailing: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.orange,
              child: Text("8", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.child_care, color: Color(0xFF4B268F)),
            title: Text("CHILDREN"),
            onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolTripScreen(),));
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail, color: Color(0xFF4B268F)),
            title: Text("CONTACT US"),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => BusDriverProfileScreen(),));
            },
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_pin, color: Color(0xFF4B268F)),
                SizedBox(width: 10),
                Icon(Icons.facebook, color: Colors.blue),
                SizedBox(width: 10),
                Icon(Icons.person_2_outlined, color: Colors.lightBlue),
                SizedBox(width: 10),
                Icon(Icons.share, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}