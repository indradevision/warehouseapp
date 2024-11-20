import 'package:flutter/material.dart';
import 'package:Warehouse/app/module/tires/tr_services.dart';
import 'package:Warehouse/app/module/tires/widgets/tr_item.dart';
import 'package:Warehouse/app/module/tires/widgets/search_component.dart';
import 'package:Warehouse/app/data/constants.dart';
import 'package:flutter/rendering.dart';

class TrIndex extends StatefulWidget {
  const TrIndex({super.key});

  @override
  State<TrIndex> createState() => _TrIndexState();
}

class _TrIndexState extends State<TrIndex> {
  final List<Map<String, dynamic>> _dataTr = [];
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

  Future<void> _fetchTrData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> data =
          await TrSummary.loadSummary(_selectedBranch, _selectedBrand);
      setState(() {
        _dataTr.clear();
        _dataTr.addAll(data);
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
          await TrGrand.loadGrandTotal(_selectedBranch, _selectedBrand);

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
    await _fetchTrData();
    await _fetchGrandTotal();
  }

  void _updateBrand(String brand) async {
    setState(() {
      _selectedBrand = brand;
    });
    await _fetchTrData();
    await _fetchGrandTotal();
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _fetchTrData();
    _fetchGrandTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        foregroundColor: Colors.white,
        title: const Text(
          "Tires",
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
                    itemCount: _dataTr.length,
                    itemBuilder: (context, index) {
                      final item = _dataTr[index];
                      return TrItem(item: item);
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
