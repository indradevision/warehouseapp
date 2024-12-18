import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Warehouse/app/data/constants.dart';
import 'package:Warehouse/app/module/order/order_services.dart';
import 'package:Warehouse/app/module/order/widgets/textfield_style.dart';
import 'package:flutter/services.dart';

class OrderSingleItem extends StatefulWidget {
  final TextEditingController descController;
  final TextEditingController quantityController;
  final TextEditingController vendorController;
  final TextEditingController itemController;
  final TextEditingController idController;
  final TextEditingController stockController;
  final TextEditingController unitController;
  final TextEditingController brandController;
  final TextEditingController? sizeController;
  final void Function(Key, String textValue) onDelete;
  final Key key;
  final int itemNumber;
  final int index;
  final String selectedEndpoint;
  // final String? selectedPart;
  // final int? selectedStock;
  // final String? selectedUnitStock;
  // final Function(
  //     {required String selectedId,
  //     required String selectedPart,
  //     required int selectedStock,
  //     required String selectedUnitStock}) storeDataItem;
  final Function({
    required Key key,
    required String selectedId,
    required String selectedPart,
    required String selectedType,
    required String selectedBrand,
    required String selectedUnitStock,
    String? selectedSize,
  }) updateSelectedItems;
  final Function({
    required Key key,
    required String selectedVendor,
  }) updateSelectedVendor;
  final Function({
    required Key key,
    required String selectedQuantity,
  }) updateSelectedQuantity;
  final Function({
    required Key key,
    required String selectedDesc,
  }) updateSelectedDesc;

  const OrderSingleItem({
    this.sizeController,
    required this.descController,
    required this.quantityController,
    required this.vendorController,
    required this.itemController,
    required this.idController,
    required this.stockController,
    required this.unitController,
    required this.brandController,
    required this.key,
    required this.onDelete,
    required this.itemNumber,
    required this.selectedEndpoint,
    required this.updateSelectedItems,
    required this.updateSelectedVendor,
    required this.updateSelectedQuantity,
    required this.updateSelectedDesc,
    required this.index,
    // this.selectedPart,
    // this.selectedStock,
    // this.selectedUnitStock
  }) : super(key: key);

  @override
  _OrderSingleItemState createState() => _OrderSingleItemState();
}

class _OrderSingleItemState extends State<OrderSingleItem> {
  String selectedType = "";
  String selectedBrand = "";
  String selectedVendor = "";
  String selectedQuantity = "";
  String _searchQuery = "";
  final List<Map<String, dynamic>> partList = [];
  final List<Map<String, dynamic>> vendorList = [];
  final List<Map<String, dynamic>> _filteredStockData = [];
  final List<Map<String, dynamic>> _filteredVendorData = [];

  Future<void> _loadPart(String selectedEndpoint) async {
    try {
      List<Map<String, dynamic>> data =
          await SpData.fetchAllData(selectedEndpoint);
      setState(() {
        partList.clear();
        partList.addAll(data);
        _filterPartData(selectedEndpoint);
      });
    } catch (e) {
      print('Failed to load PO data: $e');
    }
  }

  Future<void> _loadVendor() async {
    try {
      List<Map<String, dynamic>> data = await VData.fetchAllData();
      setState(() {
        vendorList.clear();
        vendorList.addAll(data);
        _filterVendorData();
      });
    } catch (e) {
      print('Failed to load vendor: $e ');
    }
  }

  void _filterPartData(String selectedEndpoint) {
    setState(() {
      _filteredStockData.clear();
      _filteredStockData.addAll(
        partList.where((item) {
          String nameAttribute =
              selectedEndpoint == "getalltire" ? "name_tires" : "name_part";
          return (item[nameAttribute] ?? "")
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList(),
      );
    });
  }

  void _filterVendorData() {
    setState(() {
      _filteredVendorData.clear();
      _filteredVendorData.addAll(
        vendorList.where((item) {
          String nameAttribute = 'name_vendor';
          return (item[nameAttribute] ?? "")
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList(),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPart(widget.selectedEndpoint);
    _loadVendor();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Barang ${widget.itemNumber}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (widget.itemNumber > 1)
                    ElevatedButton(
                      onPressed: () => widget.onDelete(
                        widget.key,
                        widget.itemController.text,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: Colors.grey,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Ionicons.trash_outline, size: 12),
                          SizedBox(width: 8),
                          Text('Hapus Barang', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    )
                  else
                    SizedBox.shrink(),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300, thickness: 1),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  OrderTextFormField(
                    controller: widget.itemController,
                    labelText: 'Cari Barang',
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Barang',
                                      hintText:
                                          'Pilih barang, jika sudah, tekan enter.',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                    ),
                                    onChanged: (query) {
                                      setState(() {
                                        _searchQuery = query;
                                        _filterPartData(
                                            widget.selectedEndpoint);
                                      });
                                    },
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    itemCount: _filteredStockData.length,
                                    itemBuilder: (context, index) {
                                      final item = _filteredStockData[index];
                                      return ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget.selectedEndpoint ==
                                                            "getalltire"
                                                        ? item['name_tires']
                                                        : item['name_part'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    widget.selectedEndpoint ==
                                                            "getalltire"
                                                        ? item['id_tires']
                                                        : item['id_part'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                widget.selectedEndpoint ==
                                                        "getalltire"
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade600,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        child: Text(
                                                          "SIZE ${item['size']}",
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    item['brand'],
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            widget.itemController.text =
                                                widget.selectedEndpoint ==
                                                        "getalltire"
                                                    ? item['name_tires']
                                                    : item['name_part'];
                                            widget.idController.text =
                                                widget.selectedEndpoint ==
                                                        "getalltire"
                                                    ? item['id_tires']
                                                    : item['id_part'];
                                            widget.brandController.text =
                                                item['brand'];
                                            widget.stockController.text =
                                                item['stok'].toString();
                                            widget.unitController.text =
                                                item['unit'];
                                            if (widget.selectedEndpoint ==
                                                "getalltire") {
                                              widget.sizeController?.text =
                                                  item['size'];
                                            }
                                          });
                                          Navigator.pop(context);
                                          widget.updateSelectedItems(
                                            key: widget.key,
                                            selectedId:
                                                widget.selectedEndpoint ==
                                                        "getalltire"
                                                    ? item['id_tires']
                                                    : item['id_part'],
                                            selectedPart:
                                                widget.selectedEndpoint ==
                                                        "getalltire"
                                                    ? item['name_tires']
                                                    : item['name_part'],
                                            selectedType: item['type'],
                                            selectedBrand: item['brand'],
                                            selectedUnitStock: item['unit'],
                                            selectedSize:
                                                widget.selectedEndpoint ==
                                                        "getalltire"
                                                    ? item['size']
                                                    : null,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cari barang terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: widget.itemController.value.text != null &&
                            widget.itemController.value.text.isNotEmpty
                        ? 1.0
                        : 0.0,
                    duration: Duration(milliseconds: 400),
                    child: widget.itemController.value.text != null &&
                            widget.itemController.value.text.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1.5, color: Colors.grey.shade300)),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.idController.text,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          widget.itemController.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              height: 1.3),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Stok: ${widget.stockController.text} ${widget.unitController.text}", // Ganti ini dengan data dari selectedPart jika diperlukan
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Brand",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          widget.brandController.text,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ),
                  SizedBox(height: 16),
                  widget.selectedEndpoint == "getalltire"
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: OrderTextFormField(
                            readOnly: true,
                            controller: widget.sizeController,
                            labelText: 'Ukuran',
                            hintText: 'Masukan jumlah sesuai kebutuhan',
                            keyboardType: TextInputType
                                .number, // Hanya menampilkan keyboard numerik
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly, // Hanya memperbolehkan angka
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        )
                      : SizedBox.shrink(),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: OrderTextFormField(
                            controller: widget.vendorController,
                            labelText: 'Vendor',
                            readOnly: true,
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Vendor',
                                                hintText:
                                                    'Pilih vendor, jika sudah, tekan enter.',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                filled: true,
                                                fillColor: Colors.grey.shade200,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                              ),
                                              onChanged: (query) {
                                                setState(() {
                                                  _searchQuery = query;
                                                  _filterVendorData();
                                                });
                                              },
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            color: Colors.grey.shade200,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16),
                                              itemCount:
                                                  _filteredVendorData.length,
                                              itemBuilder: (context, index) {
                                                final item =
                                                    _filteredVendorData[index];
                                                return ListTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item['name_vendor'] ??
                                                                  'Kosong',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade200,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        child: Text(
                                                          item['id_vendor'],
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedVendor =
                                                          item['name_vendor'];
                                                      widget.vendorController
                                                              .text =
                                                          selectedVendor;
                                                    });
                                                    Navigator.pop(context);
                                                    widget.updateSelectedVendor(
                                                        key: widget.key,
                                                        selectedVendor:
                                                            selectedVendor);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          )),
                      SizedBox(width: 10),
                      Expanded(
                          flex: 2,
                          child: OrderTextFormField(
                            controller: widget.quantityController,
                            labelText: 'Jumlah',
                            hintText: 'Masukan jumlah sesuai kebutuhan',
                            onChanged: (value) {
                              setState(() {
                                widget.updateSelectedQuantity(
                                    key: widget.key, selectedQuantity: value);
                              });
                            },
                            keyboardType: TextInputType
                                .number, // Hanya menampilkan keyboard numerik
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly, // Hanya memperbolehkan angka
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          )),
                      widget.itemController.text.isNotEmpty
                          ? Expanded(
                              child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade500,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                    widget.unitController.text,
                                    style: TextStyle(color: Colors.white),
                                  ))),
                            ))
                          : SizedBox.shrink()
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300, thickness: 1),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  OrderTextFormField(
                    controller: widget.descController,
                    labelText: 'Catatan Barang',
                    hintText: 'Masukkan catatan di sini',
                    onChanged: (value) {
                      setState(() {
                        widget.updateSelectedDesc(
                            key: widget.key, selectedDesc: value);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a note';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
