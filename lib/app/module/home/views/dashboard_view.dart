import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final List<Map<String, dynamic>> _stockData = [
    {"id": 1, "name": "Sparepart A", "stock": 100},
    {"id": 2, "name": "Sparepart B", "stock": 50},
    {"id": 3, "name": "Sparepart C", "stock": 200},
    {"id": 4, "name": "Sparepart D", "stock": 75},
    {"id": 5, "name": "Sparepart D", "stock": 75},
    {"id": 6, "name": "Sparepart D", "stock": 75},
    {"id": 7, "name": "Sparepart D", "stock": 75},
    {"id": 8, "name": "Sparepart D", "stock": 75},
    {"id": 9, "name": "Sparepart D", "stock": 75},
    {"id": 10, "name": "Sparepart D", "stock": 75},
  ];

  final List<Map<String, dynamic>> _regionWh = [
    {"name": "Semua"},
    {"name": "Jakarta"},
    {"name": "Solo"},
    {"name": "Bengkulu"},
    {"name": "Pekanbaru"}
  ];

  final List<Map<String, dynamic>> _typeParts = [
    {"name": "Semua"},
    {"name": "Spare Part"},
    {"name": "Ban"}
  ];

  String _selectedType = "Semua"; // Default item yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Text(
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          "Hi, Admin"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                          "Kamu mempunyai 2 pesan"),
                    ),
                  ],
                )
              ],
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 10),
              scrollDirection: Axis.horizontal,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _regionWh.map((region) {
                    return Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Center(
                        child: Text(region['name']),
                      ),
                    );
                  }).toList()),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 30),
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _typeParts.map((type) {
                  // Menggunakan GestureDetector untuk mendeteksi klik
                  return GestureDetector(
                    onTap: () {
                      // Fungsi untuk mengubah item yang dipilih
                      setState(() {
                        _selectedType =
                            type['name']; // Mengubah item yang dipilih
                      });
                      print("Item yang diklik: ${type['name']}");
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: _selectedType == type['name']
                            ? Colors.blue // Warna jika item dipilih
                            : Colors.grey[200], // Warna default
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Center(
                        child: Text(
                          type['name'],
                          style: TextStyle(
                            color: _selectedType == type['name']
                                ? Colors.white // Warna teks jika dipilih
                                : Colors.black, // Warna teks default
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
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
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Stok: ${item['stock']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
