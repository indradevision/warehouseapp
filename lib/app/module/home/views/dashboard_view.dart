import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Untuk mengonversi JSON
import 'package:Warehouse/app/data/constants.dart';
import 'package:Warehouse/app/data/api_config.dart'; // Pastikan ini sesuai dengan lokasi file Anda

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final List<Map<String, dynamic>> _stockData = [];
  final List<Map<String, dynamic>> _filteredStockData = [];

  final List<Map<String, dynamic>> _typePart = [
    {"id": "Parts", "name": "Spare Parts"},
    {"id": "Tires", "name": "Ban"}
  ];

  final List<Map<String, dynamic>> _region = [
    {"branch_id": "ALL", "name": "Semua"},
    {"branch_id": "JKT", "name": "Jakarta"},
    {"branch_id": "SOLO", "name": "Solo"},
    {"branch_id": "BKL", "name": "Bengkulu"},
    {"branch_id": "PKU", "name": "Pekanbaru"}
  ];

  String _selectedBranchId = "ALL"; // Default ID yang dipilih
  String _selectedTypeParts = "Parts"; // Default ID yang dipilih
  String _searchQuery = "";

  late String endpointSelected;

  void _selectEndpoint() {
    if (_selectedTypeParts == "Tires") {
      endpointSelected = "getalltire";
    } else {
      endpointSelected = "getallpart";
    }
  }

  @override
  void initState() {
    super.initState();
    _selectEndpoint();
    _fetchStockData();
  }

  // Fungsi untuk mengambil data dari API
  bool _isLoading = false; // Track loading state

  Future<void> _fetchStockData() async {
    setState(() {
      _isLoading = true; // Set loading to true
    });

    final response = await http.post(
      Uri.parse("$backend_url/$endpointSelected"),
      headers: {
        'Content-Type': 'application/json',
        'WAREHOUSEKEY': ApiKey.key,
      },
      body: jsonEncode({
        'branch': _selectedBranchId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      setState(() {
        _stockData.clear();
        _stockData.addAll(data.map((item) => item as Map<String, dynamic>));
        _filterStockData();
      });
    } else {
      throw Exception('Failed to load stock data');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _filterStockData() {
    setState(() {
      _filteredStockData.clear();
      _filteredStockData.addAll(
        _stockData.where((item) {
          String nameAttribute =
              (_selectedTypeParts == "Tires") ? 'name_tires' : 'name_part';
          return (item[nameAttribute] ?? "")
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: containerPadding),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: containerPadding),
                      child: Text(
                        "Hi, Admin",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Kamu mempunyai 2 pesan",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 10),
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _typePart.map((type) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTypeParts =
                          type['id']; // Mengubah ID yang dipilih
                      _selectEndpoint(); // Memilih endpoint berdasarkan tipe yang baru
                    });
                    _fetchStockData(); // Ambil data berdasarkan jenis yang dipilih
                    print("Item yang diklik: $endpointSelected");
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: _selectedTypeParts == type['id']
                          ? accentColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Center(
                      child: Text(
                        type['name'], // Tampilkan nama tipe
                        style: TextStyle(
                          color: _selectedTypeParts == type['id']
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _region.map((type) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBranchId =
                          type['branch_id']; // Mengubah ID yang dipilih
                    });
                    _fetchStockData(); // Ambil data berdasarkan jenis yang dipilih
                    print("Item yang diklik: ${type['branch_id']}");
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: _selectedBranchId == type['branch_id']
                          ? accentColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Center(
                      child: Text(
                        type['name'], // Tampilkan nama tipe
                        style: TextStyle(
                          color: _selectedBranchId == type['branch_id']
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: 20, left: containerPadding, right: containerPadding),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Pencarian',
                    hintText: 'Cari berdasarkan nama',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none, // Menghilangkan border
                    enabledBorder: InputBorder
                        .none, // Menghilangkan border saat tidak fokus
                    focusedBorder:
                        InputBorder.none, // Menghilangkan border saat fokus
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                      _filterStockData();
                    });
                  },
                )),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Show loader
                : ListView.builder(
                    itemCount: _filteredStockData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredStockData[index];
                      double halfWidth =
                          MediaQuery.of(context).size.width * 0.5;
                      String nameAttribute = (_selectedTypeParts == "Tires")
                          ? 'name_tires'
                          : 'name_part';
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: containerPadding),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: halfWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item[nameAttribute] ??
                                            "", // Tampilkan nama suku cadang
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "${item['id_branch']} - ${item['type']} ${_selectedTypeParts == "Tires" ? " - ${item['size']}" : ""}", // Tampilkan nama suku cadang
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Brand: ${item['brand']}", // Tampilkan nama suku cadang
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      )
                                    ],
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: item['stok'] == 0
                                              ? Colors.red.shade400
                                              : Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: Text(
                                        '${item['stok'] == 0 ? "Stok Habis" : "Stok Tersedia"}', // Tampilkan jumlah stok
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Stok: ${item['stok']} ${item['unit']}', // Tampilkan jumlah stok
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
