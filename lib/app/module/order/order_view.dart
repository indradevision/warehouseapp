import 'package:Warehouse/app/data/constants.dart';
import 'package:Warehouse/app/module/order/order_services.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Warehouse/app/module/order/widgets/order_item.dart';
import 'package:Warehouse/app/module/order/widgets/textfield_style.dart';
import 'package:Warehouse/app/module/global/global_services.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final _formKey = GlobalKey<FormState>();
  final _namaSparepartController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalPesanController = TextEditingController();
  final RequestPo _makeOrder = RequestPo();
  final List<Map<String, dynamic>> typeItems = [
    {"id": "Parts", "name": "Sparepart", "endpoint": "getallpart"},
    {"id": "Tires", "name": "Ban", "endpoint": "getalltire"}
  ];
  final List<Map<String, dynamic>> branchItems = [];

  String selectedType = "";
  String selectedUrl = "";
  String selectedBranch = "";
  String createdby = "rulai";
  String id_user = "";

  List id_part = [];
  List name_part = [];
  List brand = [];
  List vendor = [];
  List type = [];
  List quantity = [];
  List unit = [];
  List desc = [];
  List<Widget> _orderItems = [];

  @override
  void dispose() {
    _namaSparepartController.dispose();
    _jumlahController.dispose();
    _tanggalPesanController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadBranch();
  }

  Future<void> _loadBranch() async {
    try {
      List<Map<String, dynamic>> data = await GetBranch.fetchBranch();
      setState(() {
        branchItems.clear();
        branchItems.addAll(data);
      });
    } catch (e) {
      print("Failed fetch branch $e");
    }
  }

  Future<void> _makeRequest(BuildContext context) async {
    bool success = await _makeOrder.postRequest(
        selectedUrl,
        id_user,
        selectedBranch,
        id_part,
        name_part,
        brand,
        vendor,
        type,
        quantity,
        unit,
        desc,
        createdby);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order berhasil disetujui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyetujui order')),
      );
    }
  }

  void _addOrderItem() {
    setState(() {
      _orderItems.add(
        OrderSingleItem(
          updateSelectedItems: updateSelectedItems,
          onDelete: () => _removeOrderItem(_orderItems.length - 1),
          itemNumber: _orderItems.length + 1,
          selectedEndpoint: selectedUrl,
        ),
      );
    });
  }

  void updateSelectedItems({
    required String selectedId,
    required String selectedPart,
    required String selectedType,
    required String selectedBrand,
    required String selectedUnitStock,
  }) {
    setState(() {
      id_part.add(selectedId);
      name_part.add(selectedPart);

      print("Lokit: $id_part");
    });
  }

  void _removeOrderItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
      id_part.removeAt(index);

      print("Lokit: $id_part");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Ajukan PO')),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.grey.shade100)),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: OrderTextFormField(
                    controller: TextEditingController(text: selectedType),
                    labelText: "Jenis Barang",
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              child: ListView.builder(
                                  itemCount: typeItems.length,
                                  itemBuilder: (context, index) {
                                    final item = typeItems[index];
                                    return ListTile(
                                      title: Text(item['name']),
                                      onTap: () {
                                        setState(() {
                                          selectedType = item['id'];
                                          selectedUrl = item['endpoint'];
                                        });
                                        _orderItems.clear();
                                        Navigator.pop(context);
                                      },
                                    );
                                  }),
                            );
                          });
                    },
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: OrderTextFormField(
                    controller: TextEditingController(text: selectedBranch),
                    labelText: "Gudang",
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              child: ListView.builder(
                                itemCount: branchItems.length,
                                itemBuilder: (context, index) {
                                  final item = branchItems[index];
                                  return ListTile(
                                    title: Text(item['name_branch']),
                                    onTap: () {
                                      setState(() {
                                        selectedBranch = item['name_branch'];
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            );
                          });
                    },
                  ))
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
              Text('Tambahkan Barang', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        bottomNavigationBar: AnimatedOpacity(
          opacity: _orderItems != null && _orderItems.isNotEmpty ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: _orderItems != null && _orderItems.isNotEmpty
              ? BottomAppBar(
                  child: Container(
                    width: double
                        .infinity, // Pastikan tombol memenuhi lebar BottomAppBar
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Konfirmasi',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                content: Text(
                                  'Anda akan menginput Purchase Order baru. Apakah Anda yakin ingin melanjutkan?.',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade100,
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: Text("Batal"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text("Ajukan"),
                                  ),
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text('Ajukan Purchase Order',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ));
  }
}
