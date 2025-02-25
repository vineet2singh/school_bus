import 'package:assign_project/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:assign_project/widgets/dash_connetion_widget.dart';
class BusDriverProfileScreen extends StatelessWidget {
  const BusDriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2ECF9),
      body: Column(
        children: [
          _buildProfileHeader(context),
          _buildDriverDetails(),
          const SizedBox(height: 20),
          _buildSubscribeButton(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF2ECF9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  // Edit action
                },
              ),
            ],
          ),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/driver.jpg"), // Replace with driver image
          ),
          const SizedBox(height: 10),
          const Text(
            AppConstants.driverName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            "Active Driver",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 10),
         DashedConnectionWidget(
           startColor: Colors.green,
          endColor: Colors.orange,
          dashColor: Colors.grey,
          dashLength: 220,
          spacing: 10,
          circleSize: 10,
         )
        ],
      ),
    );
  }

  Widget _buildDriverDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start
        ,
        children: [
          _buildDetailRow(Icons.school, "School", "Doha Academy"),
          _buildDetailRow(Icons.location_on, "Pick-up Location", "Al Kinana St 1234, Al Nasr"),
          _buildDetailRow(Icons.location_on, "Drop-off Location", "Al Kinana St 5678, Al Nasr"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.purple),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          // Subscribe action
        },
        child: const Text(
          "SUBSCRIBE",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
