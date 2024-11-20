import 'package:Warehouse/app/module/data/data_index.dart';
import 'package:Warehouse/app/module/home/views/dashboard_view.dart';
import 'package:Warehouse/app/module/order/views/order_view.dart';
import 'package:Warehouse/app/module/purchase_order/po_index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  void initState() {
    super.initState();
    _loadLoginData();
  }

  Future<void> _loadLoginData() async {
    logindata = await SharedPreferences.getInstance();
    username = logindata.getString('username') ?? "Guest";
  }

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
            icon: Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Change Password'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 0) {
                Get.toNamed('/ganti-pw');
              } else if (value == 1) {
                logindata.setBool('login', false);
                logindata.clear();
                Restart.restartApp();
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
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
