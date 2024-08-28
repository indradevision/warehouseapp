import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final List<Map<String, dynamic>> _stockData = [
    {"id": 1, "name": "Sparepart A", "stock": 100},
    {"id": 2, "name": "Sparepart B", "stock": 50},
    {"id": 3, "name": "Sparepart C", "stock": 200},
    {"id": 4, "name": "Sparepart D", "stock": 75},
  ];

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              // controller: _searchController,
              // onChanged: (value) {
              //   filterStockData(value);
              // },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Nama Sparepart',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stok',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: _stockData
                      .map(
                        (item) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(item['id'].toString())),
                            DataCell(Text(item['name'])),
                            DataCell(Text(item['stock'].toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
