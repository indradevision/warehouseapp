import 'package:Warehouse/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SpItem extends StatelessWidget {
  final Map<String, dynamic> item;

  String _formatNumber(num number) {
    // Pastikan number adalah angka dan bukan null
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }

  SpItem({required this.item, Key? key}) : super(key: key);

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
                      "${item['id_branch']} - ${item['type']} ",
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
                    _buildVendorInfo(item),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "Stok: ${item['stok']}",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Harga Satuan",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  item['unit_price'] == null
                      ? "NA"
                      : "Rp ${_formatNumber(item['unit_price'])}",
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
            "Brand: ${item['brand']}",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
