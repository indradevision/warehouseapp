import 'package:Warehouse/app/module/data/views/data_view.dart';
import 'package:Warehouse/app/module/home/views/dashboard_view.dart';
import 'package:Warehouse/app/module/order/views/order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Warehouse/app/data/constants.dart';
import 'package:ionicons/ionicons.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  late SharedPreferences logindata;
  late String username;

  static final List<Widget> _widgetOptions = <Widget>[
    DashboardView(),
    OrderView(),
    DataView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Image.asset(
            'assets/images/logo-san-wider.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text('Change Password'),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('Logout'),
              ),
              // PopupMenuItem(
              //   value: 2,
              //   child: Text('Check Version'),
              // ),
            ],
            onSelected: (value) {
              if (value == 0) {
                Get.toNamed('/ganti-pw');
              } else if (value == 1) {
                logindata.setBool('login', true);
                logindata.remove('role');
                logindata.clear();
                Restart
                    .restartApp(); // Pastikan Restart sudah terkonfigurasi dengan benar
                Get.offAllNamed('/login'); // Navigasi setelah logout
              } else if (value == 2) {
                // checkver(); // Panggil fungsi untuk memeriksa versi
              }
            },
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Icon(
      //               Icons.person,
      //               size: 50,
      //               color: Colors.white,
      //             ),
      //             SizedBox(width: 16),
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Text(
      //                     'Nama Pengguna',
      //                     style: TextStyle(
      //                       fontSize: 20,
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                   SizedBox(height: 4),
      //                   Text(
      //                     'email@example.com',
      //                     style: TextStyle(
      //                       fontSize: 16,
      //                       color: Colors.white70,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         decoration: BoxDecoration(
      //           color: Colors.blueGrey,
      //         ),
      //       ),
      //       ExpansionTile(
      //         leading: Icon(Icons.list),
      //         title: Text('Purchase Order'),
      //         children: <Widget>[
      //           ListTile(
      //             title: Text('Data Order'),
      //             onTap: () {
      //               // Navigate to a specific page or perform any action
      //             },
      //           ),
      //           ListTile(
      //             title: Text('Riwayat Order'),
      //             onTap: () {
      //               // Navigate to a specific page or perform any action
      //             },
      //           ),
      //         ],
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.logout),
      //         title: Text('Logout'),
      //         onTap: () {
      //           // Perform logout action
      //           logindata.setBool('login', true);
      //           logindata.remove('role');
      //           logindata.clear();
      //           Restart.restartApp(); // Pastikan Restart sudah terkonfigurasi dengan benar
      //           Get.offAllNamed('/login'); // Navigasi setelah logout
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 0 ? Ionicons.grid : Ionicons.grid_outline),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? Ionicons.reader
                : Ionicons.reader_outline),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2
                ? Ionicons.podium
                : Ionicons.podium_outline),
            label: 'Data',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: baseColor,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
