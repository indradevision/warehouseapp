import 'package:Warehouse/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TrItem extends StatelessWidget {
  final Map<String, dynamic> item;

  String _formatNumber(num number) {
    // Pastikan number adalah angka dan bukan null
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }

  TrItem({required this.item, Key? key}) : super(key: key);

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item['id_branch']}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        item['name_brand'] ?? "",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    _buildVendorInfo(item),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Total Nilai",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  item['total_price'] == null
                      ? "NA"
                      : "Rp ${_formatNumber(item['total_price'])}",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            )
          ],
        ),
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
            "Jumlah Item: ${item['total_item']}",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
