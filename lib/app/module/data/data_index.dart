import 'package:Warehouse/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Warehouse/app/module/purchase_order/po_index.dart';
import 'package:Warehouse/app/module/spare_parts/spare_parts_index.dart';
import 'package:Warehouse/app/module/tires/tires_index.dart';

class DataView extends StatelessWidget {
  final List<Map<String, dynamic>> _listMenu = [
    {"name": "Spare Part", "page": (context) => SpIndex()},
    {"name": "Ban", "page": (context) => TrIndex()},
    {"name": "Vendor", "page": (context) => PoIndex()},
    {"name": "Brand", "page": (context) => PoIndex()},
    {"name": "Purchase Order", "page": (context) => PoIndex()},
  ];
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
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: _listMenu.map((menu) {
                  return Card(
                    color: baseColor,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => menu['page'](context),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(Ionicons.albums_outline,
                                size: 30, color: Colors.white),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu['name'],
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  menu['name'],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                              ],
                            )
                            // Text(
                            //   '120',
                            //   style: TextStyle(fontSize: 18, color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
