import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PoItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const PoItem({Key? key, required this.item}) : super(key: key);

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
      padding: const EdgeInsets.only(top: 5),
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
                leading: Icon(Ionicons.checkmark_circle_outline),
                title: Text('Setujui'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Ionicons.arrow_down_circle_outline),
                title: Text('Download'),
                onTap: () {
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
