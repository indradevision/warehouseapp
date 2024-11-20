import 'package:Warehouse/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Warehouse/app/module/purchase_order/po_index.dart';
import 'package:Warehouse/app/module/spare_parts/spare_parts_index.dart';
import 'package:Warehouse/app/module/vendor/vendor_index.dart';
import 'package:Warehouse/app/module/tires/tires_index.dart';

class DataView extends StatelessWidget {
  final List<Map<String, dynamic>> _listMenu = [
    {
      "name": "Spare Part",
      "page": (context) => SpIndex(),
      "images": "assets/images/sp-il.jpg", // No need to use function
    },
    {
      "name": "Ban",
      "page": (context) => TrIndex(),
      "images": "assets/images/tr-il.jpg"
    },
    {
      "name": "Vendor",
      "page": (context) => VrIndex(),
      "images": "assets/images/jb-il.jpg"
    },
    {
      "name": "Purchase Order",
      "page": (context) => PoIndex(),
      "images": "assets/images/po-il.jpg"
    },
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
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: _listMenu.map((menu) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg-item.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => menu['page'](context),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(menu['images']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu['name'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  menu['name'],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black45),
                                ),
                              ],
                            ),
                          )
                          // Text(
                          //   '120',
                          //   style: TextStyle(fontSize: 18, color: Colors.white),
                          // ),
                        ],
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
