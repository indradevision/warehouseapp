import 'package:flutter/material.dart';
import 'package:Warehouse/app/module/spare_parts/sp_services.dart';
import 'package:Warehouse/app/module/spare_parts/widgets/sp_item.dart';
import 'package:flutter/rendering.dart';

class SpIndex extends StatefulWidget {
  const SpIndex({super.key});

  @override
  State<SpIndex> createState() => _SpIndexState();
}

class _SpIndexState extends State<SpIndex> {
  final List<Map<String, dynamic>> _dataSp = [];
  bool _isLoading = false;
  String selectedFromDate = DateTime.now()
      .subtract(Duration(days: 30))
      .toIso8601String()
      .split('T')
      .first;
  String selectedToDate = DateTime.now().toIso8601String().split('T').first;
  String selectedBranch = "SOLO";

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _fetchPoData();
  }

  Future<void> _fetchPoData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> data = await SpService.fetchPoData();
      setState(() {
        _dataSp.clear();
        _dataSp.addAll(data);
      });
    } catch (e) {
      print('Failed to load PO data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Spare Parts"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _controller,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _dataSp.length,
              itemBuilder: (context, index) {
                final item = _dataSp[index];
                return SpItem(item: item);
              },
            ),
    );
  }
}
