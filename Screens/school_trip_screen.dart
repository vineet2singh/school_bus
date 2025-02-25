import 'package:flutter/material.dart';

class SchoolTripScreen extends StatefulWidget {
  @override
  _SchoolTripScreenState createState() => _SchoolTripScreenState();
}

class _SchoolTripScreenState extends State<SchoolTripScreen> {
  List<Student> students = List.generate(
    5,
    (index) => Student(name: "Asma Al Malki", isComing: null),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("School Trip"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "The school trip is about to start. Please confirm who is coming.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return StudentCard(
                  student: students[index],
                  onConfirm: (isComing) {
                    setState(() {
                      students[index].isComing = isComing;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle confirmation logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Confirmations saved!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
            ),
            child: Text("CONFIRM"),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final Student student;
  final Function(bool) onConfirm;

  const StudentCard({
    required this.student,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/profile.png"),
                ),
                SizedBox(width: 10),
                Text(
                  student.name,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Spacer(),
                if (student.isComing != null)
                  Icon(
                    student.isComing! ? Icons.check_circle : Icons.cancel,
                    color: student.isComing! ? Colors.green : Colors.red,
                  )
              ],
            ),
            if (student.isComing == null || student.isComing == false) ...[
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.location_on, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.white),
                    onPressed: () {},
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => onConfirm(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: student.isComing == true ? Colors.green : Colors.grey,
                    ),
                    child: Text("Coming"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => onConfirm(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: student.isComing == false ? Colors.red : Colors.grey,
                    ),
                    child: Text("Not coming"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Student {
  String name;
  bool? isComing;
  Student({required this.name, this.isComing});
}
