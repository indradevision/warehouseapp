import 'package:Warehouse/app/data/constants.dart';
import 'package:Warehouse/app/module/purchase_order/po_services.dart';
import 'package:Warehouse/app/module/purchase_order/widgets/po_single_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PoSingle extends StatefulWidget {
  final String idOrder;
  final String vendor;

  const PoSingle({super.key, required this.idOrder, required this.vendor});

  @override
  State<PoSingle> createState() => _PoSingleState();
}

class _PoSingleState extends State<PoSingle> {
  Map<String, dynamic>? _orderData; // Data utama order
  List<Map<String, dynamic>> _detailData = []; // List detail order
  bool _isLoading = false;

  Future<void> _fetchPoSingleData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await PoSingleService.fetchSingleData(
        widget.idOrder,
        widget.vendor,
      );

      setState(() {
        _orderData = data;
        _detailData = List<Map<String, dynamic>>.from(data['detail']);
      });
    } catch (e) {
      print('Failed to load PO data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPoSingleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        foregroundColor: Colors.white,
        title: Text(
          _orderData?['id_order'] ?? "Order Detail",
          style: TextStyle(fontSize: 18),
        ),
        scrolledUnderElevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: baseColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Diorder oleh",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                              Text(
                                _orderData?['createdby'] ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Pada ${_orderData?['date_issued']} Jam ${_orderData?['time']}",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width:
                                    36, // Width and height should be the same for a circle
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _orderData?['approved'] == "0"
                                      ? Colors.yellow.shade100
                                      : Colors
                                          .green, // Background color of the circle
                                  shape: BoxShape
                                      .circle, // Makes the container circular
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: Offset(0, 4), // Shadow position
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _orderData?['approved'] == "0"
                                      ? Ionicons.time_outline
                                      : Ionicons.checkmark_outline,
                                  color: _orderData?['approved'] == "0"
                                      ? Colors.amber
                                      : Colors.white,
                                  size: 20, // Size of the icon
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _orderData?['approved'] == "0"
                                    ? "Belum Disetujui"
                                    : "Disetujui",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _detailData.length,
                          itemBuilder: (context, index) {
                            final item = _detailData[index];
                            return PoSingleItem(item: item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: (_orderData?['note'] != null &&
              _orderData?['note'].isNotEmpty)
          ? BottomAppBar(
              height: 120,
              elevation: 30,
              shadowColor: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Catatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        _orderData?['note'],
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(), // Use SizedBox.shrink() to show nothing
    );
  }
}
