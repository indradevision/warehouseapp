import 'package:Warehouse/app/module/data/data_index.dart';
import 'package:Warehouse/app/module/home/views/dashboard_view.dart';
import 'package:Warehouse/app/module/order/order_view.dart';
import 'package:Warehouse/app/module/purchase_order/po_index.dart';
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
    PoIndex(),
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
        backgroundColor: Colors.grey.shade200,
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
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: <Color>[
                          Color.fromARGB(255, 0, 179, 255),
                          Color(0xFF0026ff)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Ionicons.grid,
                      color: Colors
                          .white, // Warna ini akan diabaikan karena gradien
                    ),
                  )
                : Icon(Ionicons.grid_outline),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: <Color>[
                          Color.fromARGB(255, 0, 179, 255),
                          Color(0xFF0026ff)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Ionicons.reader,
                      color: Colors.white,
                    ),
                  )
                : Icon(Ionicons.reader_outline),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: <Color>[
                          Color.fromARGB(255, 0, 179, 255),
                          Color(0xFF0026ff)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Ionicons.podium,
                      color: Colors.white,
                    ),
                  )
                : Icon(Ionicons.podium_outline),
            label: 'Data',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            baseColor, // Diabaikan karena kita menggunakan ShaderMask
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
