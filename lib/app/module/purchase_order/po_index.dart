import 'package:Warehouse/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:Warehouse/app/module/purchase_order/widgets/po_item.dart';
import 'package:Warehouse/app/module/purchase_order/widgets/po_bottom_appbar.dart';
import 'package:Warehouse/app/module/purchase_order/po_services.dart';
import 'package:Warehouse/app/module/order/order_view.dart';
import 'package:flutter/rendering.dart';

class PoIndex extends StatefulWidget {
  const PoIndex({super.key});

  @override
  State<PoIndex> createState() => _PoIndexState();
}

class _PoIndexState extends State<PoIndex> {
  final List<Map<String, dynamic>> _dataPo = [];
  bool _isLoading = false;
  bool _showFab = true;
  bool _isElevated = true;
  bool _isVisible = true;
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
    _controller.addListener(_listen);
    _fetchPoData();
  }

  @override
  void dispose() {
    _controller.removeListener(_listen);
    _controller.dispose();
    super.dispose();
  }

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

  void _listen() {
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      _show();
    } else if (_controller.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _hide();
    }
  }

  void _show() {
    if (!_isVisible) {
      setState(() => _isVisible = true);
    }
  }

  void _hide() {
    if (_isVisible) {
      setState(() => _isVisible = false);
    }
  }

  void _onFromDateChanged(String newDate) {
    setState(() {
      selectedFromDate = newDate; // Update the selected From date
    });
    _fetchPoData(); // Fetch data after changing the date
  }

  void _onToDateChanged(String newDate) {
    setState(() {
      selectedToDate = newDate; // Update the selected To date
    });
    _fetchPoData(); // Fetch data after changing the date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Purchase Order"),
        scrolledUnderElevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _controller,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _dataPo.length,
              itemBuilder: (context, index) {
                final item = _dataPo[index];
                return PoItem(
                  item: item,
                  onApprove: _fetchPoData,
                );
              },
            ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              backgroundColor: baseColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderView()));
              },
              tooltip: 'Buat Order',
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: _isVisible
          ? FloatingActionButtonLocation.endContained
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: PoBottomAppbar(
        isElevated: _isElevated,
        isVisible: _isVisible,
        fromDateValue: selectedFromDate,
        toDateValue: selectedToDate,
        onFromDateChanged: _onFromDateChanged, // Pass the callback
        onToDateChanged: _onToDateChanged, // Pass the callback
      ),
    );
  }
}
