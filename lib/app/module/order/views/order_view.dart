import 'package:flutter/material.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final _formKey = GlobalKey<FormState>();
  final _namaSparepartController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalPesanController = TextEditingController();

  @override
  void dispose() {
    _namaSparepartController.dispose();
    _jumlahController.dispose();
    _tanggalPesanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Order Sparepart'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              TextFormField(
                controller: _namaSparepartController,
                decoration: InputDecoration(
                  labelText: 'Nama Sparepart',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama sparepart tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _tanggalPesanController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pesan',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal pesan tidak boleh kosong';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _tanggalPesanController.text = "${picked.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Proses data
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Memproses Pesanan')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[400],
                  shadowColor: Colors.purple[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Pesan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
