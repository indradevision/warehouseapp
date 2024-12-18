import 'package:Warehouse/app/data/constants.dart';
import 'package:Warehouse/app/module/order/order_services.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Warehouse/app/module/order/widgets/order_item.dart';
import 'package:Warehouse/app/module/order/widgets/textfield_style.dart';
import 'package:Warehouse/app/module/global/global_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> getUserPref() async {
    final prefs = await SharedPreferences.getInstance();

    final String? userName = prefs.getString('userName');

    final int? idUser = prefs.getInt('idUser');

    setState(() {
      createdby = userName ?? '';
      id_user = idUser ?? 0;
    });

    print(id_user);
  }

  String selectedType = "";
  String selectedUrl = "";
  String selectedBranch = "";
  String createdby = "";
  int id_user = 0;

  List<OrderSingleItem> _orderItems = [];
  List<Map<String, TextEditingController>> controllers = [];
  List<Key> itemKeys = [];
  List id_part = [];
  List name_part = [];
  List brand = [];
  List vendor = [];
  List type = [];
  List quantity = [];
  List unit = [];
  List desc = [];
  List size = [];

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
    id_part = [];
    name_part = [];
    brand = [];
    vendor = [];
    type = [];
    quantity = [];
    unit = [];
    desc = [];
    size = [];
    getUserPref();
  }

  Future<void> _loadBranch() async {
    try {
      List<Map<String, dynamic>> data = await GetWithoutAllBranch.fetchBranch();
      setState(() {
        branchItems.clear();
        branchItems.addAll(data);
      });
    } catch (e) {
      print("Failed fetch branch $e");
    }
  }

  void _showStatusDialog({
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          content: Text(
            content,
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makeRequest(BuildContext context) async {
    print("jalan");
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
      size,
      createdby,
    );

    if (!mounted) return;

    if (success) {
      print("Sukses");
      _showStatusDialog(
          title: "Berhasil",
          content:
              "Purchase order anda berhasil diajukan, dan akan segera diproses oleh admin.");
      clearAllLists();
      setState(() {});
    } else {
      _showStatusDialog(
          title: "Gagal", content: "Purchase order anda gagal diajukan.");
    }
  }

  void _addOrderItem() {
    setState(() {
      TextEditingController descController = TextEditingController();
      TextEditingController quantityController = TextEditingController();
      TextEditingController vendorController = TextEditingController();
      TextEditingController itemController = TextEditingController();
      TextEditingController idController = TextEditingController();
      TextEditingController brandController = TextEditingController();
      TextEditingController stockController = TextEditingController();
      TextEditingController unitController = TextEditingController();
      TextEditingController sizeController = TextEditingController();
      Key newItemKey = UniqueKey();
      if (vendorController.text.isEmpty) {
        vendor.add("");
      }
      if (quantityController.text.isEmpty) {
        quantity.add("");
      }
      if (descController.text.isEmpty) {
        desc.add("");
      }
      _orderItems.add(
        OrderSingleItem(
          key: newItemKey,
          index: _orderItems.length,
          updateSelectedItems: updateSelectedItems,
          updateSelectedVendor: updateSelectedVendor,
          updateSelectedQuantity: updateSelectedQuantity,
          updateSelectedDesc: updateSelectedDesc,
          onDelete: (key, String) =>
              _removeOrderItem(newItemKey, itemController.text),
          itemNumber: _orderItems.length + 1,
          selectedEndpoint: selectedUrl,
          itemController: itemController,
          vendorController: vendorController,
          quantityController: quantityController,
          descController: descController,
          idController: idController,
          brandController: brandController,
          stockController: stockController,
          unitController: unitController,
          sizeController: sizeController,
        ),
      );
      itemKeys.add(newItemKey);
      controllers.add({
        'vendor': vendorController,
        'item': itemController,
        'quantity': quantityController,
        'desc': descController,
      });
    });
  }

  void updateSelectedVendor(
      {required Key key, required String selectedVendor}) {
    setState(() {
      var itemIndex = _orderItems.indexWhere((item) => item.key == key);

      if (itemIndex >= 0 && itemIndex < vendor.length) {
        setState(() {
          vendor[itemIndex] = '$selectedVendor';
        });
      } else {
        setState(() {
          vendor.add('$selectedVendor');
        });
      }
      print(vendor);
    });
  }

  void updateSelectedQuantity(
      {required Key key, required String selectedQuantity}) {
    setState(() {
      var itemIndex = _orderItems.indexWhere((item) => item.key == key);

      if (itemIndex >= 0 && itemIndex < quantity.length) {
        setState(() {
          quantity[itemIndex] = '$selectedQuantity';
        });
      } else {
        setState(() {
          quantity.add('$selectedQuantity');
        });
      }
      print(quantity);
    });
  }

  void updateSelectedDesc({required Key key, required String selectedDesc}) {
    setState(() {
      var itemIndex = _orderItems.indexWhere((item) => item.key == key);

      if (itemIndex >= 0 && itemIndex < desc.length) {
        setState(() {
          desc[itemIndex] = '$selectedDesc';
        });
      } else {
        setState(() {
          desc.add('$selectedDesc');
        });
      }
      print(desc);
    });
  }

  void updateSelectedItems({
    required Key key,
    required String selectedId,
    required String selectedPart,
    required String selectedType,
    required String selectedBrand,
    required String selectedUnitStock,
    String? selectedSize,
  }) {
    setState(() {
      var itemIndex = _orderItems.indexWhere((item) => item.key == key);

      print("Nomor ${itemIndex}");

      if (itemIndex >= 0 && itemIndex < name_part.length) {
        setState(() {
          // name_part[itemIndex] = '"$selectedPart"';
          id_part[itemIndex] = '$selectedId';
          name_part[itemIndex] = '$selectedPart';
          brand[itemIndex] = '$selectedBrand';
          type[itemIndex] = '$selectedType';
          unit[itemIndex] = '$selectedUnitStock';
          size[itemIndex] = '$selectedSize';
          print("Item Update: $name_part");
        });
      } else {
        setState(() {
          id_part.add('$selectedId');
          name_part.add('$selectedPart');
          brand.add('$selectedBrand');
          type.add('$selectedType');
          unit.add('$selectedUnitStock');
          size.add('$selectedSize');
          // vendor.add('""');
          // quantity.add('""$');
          // desc.add('""$');
        });
        print("Item Add: $name_part");
        // print("Tambah");
        // print(id_part);
        // print(name_part);
        // print(brand);
        // print(type);
        // print(unit);
      }
    });
  }

  void _removeOrderItem(Key itemKey, String textValue) {
    setState(() {
      int index = itemKeys.indexOf(itemKey);
      if (index != -1) {
        // Controller
        controllers[index]['quantity']?.dispose();
        controllers[index]['vendor']?.dispose();
        controllers[index]['item']?.dispose();
        controllers.removeAt(index);
        // Item
        _orderItems.removeAt(index);
        itemKeys.removeAt(index);
        // Item detail
        if (textValue.isNotEmpty) {
          id_part.removeAt(index);
          name_part.removeAt(index);
          brand.removeAt(index);
          type.removeAt(index);
          unit.removeAt(index);
          size.removeAt(index);
        }
        // Vendor
        vendor.removeAt(index);
        quantity.removeAt(index);
        desc.removeAt(index);

        print('Delete Item: $size');
      }
    });
  }

  List<List<dynamic>> get allLists => [
        _orderItems,
        controllers,
        itemKeys,
        id_part,
        name_part,
        brand,
        vendor,
        type,
        quantity,
        unit,
        desc,
        size,
      ];

  void clearAllLists() {
    for (var list in allLists) {
      list.clear();
    }
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
                                        clearAllLists();
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
                                        selectedBranch = item['id_branch'];
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
                child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: _orderItems.isEmpty ? 1 : _orderItems.length,
              itemBuilder: (context, index) {
                if (_orderItems.isEmpty) {
                  return Column(
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
                      ),
                    ],
                  );
                } else {
                  return _orderItems[index];
                }
              },
            )),
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                content: Text(
                                  'Anda akan menginput Purchase Order baru. Apakah Anda yakin ingin melanjutkan?.',
                                  style: TextStyle(color: Colors.black54),
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
                                    onPressed: () {
                                      _makeRequest(context);
                                      Navigator.pop(context);
                                    },
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
