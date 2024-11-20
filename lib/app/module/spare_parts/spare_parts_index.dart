import 'package:Warehouse/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:Warehouse/app/module/spare_parts/sp_services.dart';
import 'package:Warehouse/app/module/spare_parts/widgets/sp_item.dart';
import 'package:Warehouse/app/module/spare_parts/widgets/search_component.dart';
import 'package:flutter/rendering.dart';

class SpIndex extends StatefulWidget {
  const SpIndex({super.key});

  @override
  State<SpIndex> createState() => _SpIndexState();
}

class _SpIndexState extends State<SpIndex> {
  final List<Map<String, dynamic>> _dataSp = [];
  bool _isLoading = false;
  String _selectedBranch = "ALL";
  String _selectedBrand = "ALL";
  int _grandTotal = 0;

  late ScrollController _controller;

  String _formatNumber(num number) {
    // Pastikan number adalah angka dan bukan null
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }

  Future<void> _fetchSpData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> data =
          await SpSummary.loadSummary(_selectedBranch, _selectedBrand);
      setState(() {
        _dataSp.clear();
        _dataSp.addAll(data);
      });
    } catch (e) {
      print('Failed to load main index data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchGrandTotal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      int grandTotal =
          await SpGrand.loadGrandTotal(_selectedBranch, _selectedBrand);

      setState(() {
        _grandTotal = grandTotal;
      });
    } catch (e) {
      print('Failed to load main index data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _updateBranch(String branch) async {
    setState(() {
      _selectedBranch = branch;
    });
    await _fetchSpData();
    await _fetchGrandTotal();
  }

  void _updateBrand(String brand) async {
    setState(() {
      _selectedBrand = brand;
    });
    await _fetchSpData();
    await _fetchGrandTotal();
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _fetchSpData();
    _fetchGrandTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        foregroundColor: Colors.white,
        title: const Text(
          "Spare Parts",
          style: TextStyle(color: Colors.white),
        ),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: SearchComponent(
                updateBranch: _updateBranch,
                updateBrand: _updateBrand,
              )),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: _dataSp.length,
                    itemBuilder: (context, index) {
                      final item = _dataSp[index];
                      return SpItem(item: item);
                    },
                  ),
                ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        shadowColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Grand Total",
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              "Rp ${_formatNumber(_grandTotal)}",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
