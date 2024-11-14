import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Warehouse/app/module/purchase_order/po_services.dart';
import 'package:Warehouse/app/module/purchase_order/po_single.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Warehouse/app/module/purchase_order/widgets/po_single_item.dart';
import 'dart:convert';

class PoItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final OrderService _orderService = OrderService();
  final DownloadService _downloadService = DownloadService();
  final Future<void> Function() onApprove;

  Future<void> _approveOrder(BuildContext context) async {
    bool success = await _orderService.approveOrder(item['id_order']);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order berhasil disetujui')),
      );
      await onApprove();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyetujui order')),
      );
    }
  }

  Future<void> _downloadDoc(
      BuildContext context, String idOrder, String nameVendor) async {
    try {
      String success = await _downloadService.downloadDoc(idOrder, nameVendor);
      final successDecode = jsonDecode(success);

      if (successDecode != null &&
          successDecode['data'] != null &&
          successDecode['data']['link'] != null) {
        final downloadadedLink = successDecode['data']['link'];
        if (!await launchUrl(Uri.parse(downloadadedLink),
            mode: LaunchMode.inAppBrowserView)) {
          throw Exception('Could not launch $downloadadedLink');
        }
      } else {
        print('Link tidak tersedia.');
      }
    } catch (e) {
      print('Error downloading document: $e');
    }
  }

  PoItem({required this.item, required this.onApprove, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item['approved'] == "1"
                        ? Colors.lightGreen.shade100
                        : Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Icon(
                      item['approved'] == "1"
                          ? Ionicons.checkmark_circle_outline
                          : Ionicons.time_outline,
                      color:
                          item['approved'] == "1" ? Colors.green : Colors.amber,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['id_order'] ?? "",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        item['name_part'] ?? "",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    _buildStatusRow(item),
                    _buildVendorInfo(item),
                  ],
                ),
              ],
            ),
            IconButton(
              icon:
                  Icon(Ionicons.ellipsis_vertical_sharp, color: Colors.black54),
              onPressed: () => _showBottomSheet(context, item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          _buildStatusChip('Sudah Input', item['input'] != "0"),
          SizedBox(width: 5),
          _buildStatusChip('Proses', item['print'] != "0"),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 9, color: isActive ? Colors.white : Colors.grey.shade400),
      ),
    );
  }

  Widget _buildVendorInfo(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Brand: ${item['brand']}",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text(
            "${item['vendor']}",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${item['name_part']}"),
                    Text(
                      "${item['id_order']}",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Ionicons.eye_outline),
                title: Text('Selengkapnya'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PoSingle(
                                idOrder: item['id_order'],
                                vendor: item['vendor'],
                              )));
                },
              ),
              ListTile(
                leading: Icon(Ionicons.checkmark_circle_outline),
                title: Text('Setujui'),
                onTap: () {
                  _approveOrder(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Ionicons.arrow_down_circle_outline),
                title: Text('Download'),
                onTap: () {
                  _downloadDoc(context, item['id_order'], item['vendor']);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
