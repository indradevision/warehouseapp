import 'package:Warehouse/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Warehouse/app/module/order/widgets/order_item.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final _formKey = GlobalKey<FormState>();
  final _namaSparepartController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalPesanController = TextEditingController();

  // List untuk menyimpan item-item form
  List<Widget> _orderItems = [];

  // Ngitung
  // int _itemCount = 1;

  @override
  void dispose() {
    _namaSparepartController.dispose();
    _jumlahController.dispose();
    _tanggalPesanController.dispose();
    super.dispose();
  }

  // Fungsi untuk menambahkan item baru ke dalam list
  void _addOrderItem() {
    setState(() {
      _orderItems.add(
        OrderSingleItem(
            onDelete: () => _removeOrderItem(_orderItems.length - 1),
            itemNumber: _orderItems.length + 1),
      );
    });
  }

  // Fungsi untuk menghapus item dari list
  void _removeOrderItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order View')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  if (_orderItems.isEmpty)
                    Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Image.asset(
                            'assets/images/empty-box.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Barang Kosong",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Tambahkan barang terlebih dahulu",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    )
                  else
                    ..._orderItems,
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _addOrderItem,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: baseColor,
          foregroundColor: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Ionicons.add_outline, size: 20),
            SizedBox(width: 8),
            Text('Tambahkan Barang', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
