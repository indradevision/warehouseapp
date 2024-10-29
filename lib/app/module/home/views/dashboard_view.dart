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
  Future<void> _fetchStockData() async {
    final response = await http.post(
      Uri.parse(
          "$backend_url/$endpointSelected"), // Menggunakan endpoint yang sesuai
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
        _stockData.clear(); // Kosongkan data sebelumnya
        _stockData.addAll(data.map(
            (item) => item as Map<String, dynamic>)); // Tambahkan data baru
      });
    } else {
      throw Exception('Failed to load stock data');
    }
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
                          : Colors.grey[200],
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
            padding: EdgeInsets.only(bottom: 30),
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
                          : Colors.grey[200],
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
                bottom: 30, left: containerPadding, right: containerPadding),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pencarian',
                hintText: 'Cari berdasarkan nama',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _stockData.length,
              itemBuilder: (context, index) {
                final item = _stockData[index];
                double halfWidth = MediaQuery.of(context).size.width * 0.5;
                String nameAttribute = (_selectedTypeParts == "Tires")
                    ? 'name_tires'
                    : 'name_part';
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: containerPadding),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: halfWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item[nameAttribute] ??
                                      "Data Tidak Tersedia", // Tampilkan nama suku cadang
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${item['id_branch']} - ${item['type']}", // Tampilkan nama suku cadang
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                )
                              ],
                            )),
                        Text(
                          'Stok: ${item['stok']} ${item['unit']}', // Tampilkan jumlah stok
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
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
