import 'package:flutter/material.dart';
import 'package:Warehouse/app/module/vendor/vr_services.dart';
import 'package:Warehouse/app/module/vendor/widgets/vr_item.dart';
import 'package:flutter/rendering.dart';

class VrIndex extends StatefulWidget {
  const VrIndex({super.key});

  @override
  State<VrIndex> createState() => _VrIndexState();
}

class _VrIndexState extends State<VrIndex> {
  final List<Map<String, dynamic>> _dataVr = [];
  bool _isLoading = false;

  Future<void> _fetchTrData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> data = await VrData.loadVendor();
      setState(() {
        _dataVr.clear();
        _dataVr.addAll(data);
      });
    } catch (e) {
      print('Failed to load main index data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTrData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Vendor"),
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: _dataVr.length,
                      itemBuilder: (context, index) {
                        final item = _dataVr[index];
                        return VrItem(item: item);
                      },
                    ),
                  ),
          ],
        ));
  }
}
