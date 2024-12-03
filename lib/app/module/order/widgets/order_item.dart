import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Warehouse/app/data/constants.dart';
import 'package:Warehouse/app/module/order/order_services.dart';
import 'package:Warehouse/app/module/order/widgets/textfield_style.dart';
import 'package:flutter/services.dart';

class OrderSingleItem extends StatefulWidget {
  final VoidCallback onDelete;
  final int itemNumber;
  final String selectedEndpoint;
  final Function({
    required String selectedId,
    required String selectedPart,
    required String selectedType,
    required String selectedBrand,
    required String selectedUnitStock,
  }) updateSelectedItems;

  const OrderSingleItem(
      {Key? key,
      required this.onDelete,
      required this.itemNumber,
      required this.selectedEndpoint,
      required this.updateSelectedItems})
      : super(key: key);

  @override
  _OrderSingleItemState createState() => _OrderSingleItemState();
}

class _OrderSingleItemState extends State<OrderSingleItem> {
  String selectedId = "";
  String selectedPart = "";
  int selectedStock = 99;
  String selectedType = "";
  String selectedBrand = "";
  String selectedUnitStock = "";
  String selectedVendor = "";
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
                  ElevatedButton(
                    onPressed: widget.onDelete,
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
                    controller: TextEditingController(text: selectedPart),
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
                                            selectedId =
                                                widget.selectedEndpoint ==
                                                        "getalltire"
                                                    ? item['id_tires']
                                                    : item['id_part'];
                                            selectedPart =
                                                widget.selectedEndpoint ==
                                                        "getalltire"
                                                    ? item['name_tires']
                                                    : item['name_part'];
                                            selectedStock = item['stok'];
                                            selectedType = item['type'];
                                            selectedBrand = item['brand'];
                                            selectedUnitStock = item['unit'];
                                          });
                                          Navigator.pop(context);

                                          widget.updateSelectedItems(
                                            selectedId: selectedId,
                                            selectedPart: selectedPart,
                                            selectedType: selectedType,
                                            selectedBrand: selectedBrand,
                                            selectedUnitStock:
                                                selectedUnitStock,
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
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: selectedPart != null && selectedPart.isNotEmpty
                        ? 1.0
                        : 0.0,
                    duration: Duration(milliseconds: 400),
                    child: selectedPart != null && selectedPart.isNotEmpty
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
                                        selectedId,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          selectedPart, // Ganti ini dengan data dari selectedPart jika diperlukan
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              height: 1.3),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Stok: ${selectedStock} ${selectedUnitStock}", // Ganti ini dengan data dari selectedPart jika diperlukan
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
                                          selectedType,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          selectedBrand,
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
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: OrderTextFormField(
                            controller:
                                TextEditingController(text: selectedVendor),
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
                                                    });
                                                    Navigator.pop(context);
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
                            labelText: 'Jumlah',
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
                          )),
                      selectedUnitStock.isNotEmpty
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
                                    selectedUnitStock,
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
                    labelText: 'Catatan Barang',
                    hintText: 'Masukkan catatan di sini',
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
