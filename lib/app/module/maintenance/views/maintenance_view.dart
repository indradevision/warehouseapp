import 'package:Warehouse/app/data/tampungdata.dart';
import 'package:Warehouse/app/module/maintenance/controllers/maintenance_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MaintenanceView extends GetView<MaintenanceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Container(
                child: Text(
                  "${Maintenance.message}",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
