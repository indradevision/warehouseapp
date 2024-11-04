import 'package:flutter/material.dart';
import 'package:Warehouse/app/module/purchase_order/widgets/po_item.dart';
import 'package:Warehouse/app/module/purchase_order/po_services.dart';
import 'package:ionicons/ionicons.dart';

class PoIndex extends StatefulWidget {
  const PoIndex({super.key});

  @override
  State<PoIndex> createState() => _PoIndexState();
}

class _PoIndexState extends State<PoIndex> {
  final List<Map<String, dynamic>> _dataPo = [];
  bool _isLoading = false;
  String selectedFromDate = DateTime.now()
      .subtract(Duration(days: 30))
      .toIso8601String()
      .split('T')
      .first;
  String selectedToDate = DateTime.now().toIso8601String().split('T').first;
  String selectedBranch = "SOLO";

  Future<void> _fetchPoData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> data = await PoService.fetchPoData(
        selectedFromDate,
        selectedToDate,
        selectedBranch,
      );
      setState(() {
        _dataPo.clear();
        _dataPo.addAll(data);
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
    _fetchPoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Purchase Order"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _dataPo.length,
              itemBuilder: (context, index) {
                final item = _dataPo[index];
                return PoItem(item: item);
              },
            ),
    );
  }
}
