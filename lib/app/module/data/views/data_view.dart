import 'package:flutter/material.dart';

class DataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   'Dashboard',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  Card(
                    color: Colors.blue,
                    child: InkWell(
                      onTap: () {
                        // Aksi ketika card ditekan
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.bus_alert, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Spare Parts',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            // Text(
                            //   '120',
                            //   style: TextStyle(fontSize: 18, color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        // Aksi ketika card ditekan
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.tire_repair, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Ban',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            // Text(
                            //   '12',
                            //   style: TextStyle(fontSize: 18, color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.orange,
                    child: InkWell(
                      onTap: () {
                        // Aksi ketika card ditekan
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.people, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Vendor',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            // Text(
                            //   '30',
                            //   style: TextStyle(fontSize: 18, color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.red,
                    child: InkWell(
                      onTap: () {
                        // Aksi ketika card ditekan
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.label, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              'Brand',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            // Text(
                            //   '5',
                            //   style: TextStyle(fontSize: 18, color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
