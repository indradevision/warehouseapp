import 'package:flutter/material.dart';
import 'package:Warehouse/app/module/spare_parts/sp_services.dart';
import 'package:Warehouse/app/module/global/global_services.dart';

class SearchComponent extends StatefulWidget {
  // final String selectedBranch;
  // final String selectedBrand;
  // final String selectedBatchSel;
  final Function(String) updateBranch;
  final Function(String) updateBrand;

  const SearchComponent(
      {Key? key,
      // required this.selectedBranch,
      // required this.selectedBrand,
      // required this.selectedBatchSel,
      required this.updateBranch,
      required this.updateBrand})
      : super(key: key);
  // const SearchComponent({super.key});
  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  String selectedBranch = "ALL";
  String selectedBrand = "ALL";
  String selectedBatchSel = "ALL";

  final List<Map<String, dynamic>> brandList = [];
  final List<Map<String, dynamic>> sumList = [];
  final List<Map<String, dynamic>> branchList = [];

  Future<void> _loadBrand() async {
    try {
      List<Map<String, dynamic>> data = await SpBrand.loadBrand();
      setState(() {
        brandList.clear();
        brandList.addAll(data);
      });
    } catch (e) {
      print('Failed to load PO data: $e');
    }
  }

  Future<void> _loadSummary() async {
    try {
      List<Map<String, dynamic>> data =
          await SpSummary.loadSummary(selectedBranch, selectedBatchSel);
      setState(() {
        sumList.clear();
        sumList.addAll(data);
      });
    } catch (e) {
      print('Failed to load PO data: $e');
    }
  }

  Future<void> _loadBranch() async {
    try {
      List<Map<String, dynamic>> data = await GetBranch.fetchBranch();
      setState(() {
        branchList.clear();
        branchList.addAll(data);
      });
    } catch (e) {
      print('Failed to load branch');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBrand();
    _loadBranch();
    _loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: TextEditingController(text: selectedBranch),
            readOnly: true, // Make it readonly so the user can't edit directly
            onTap: () {
              // Show the bottom sheet when the TextField is tapped
              showModalBottomSheet(
                backgroundColor: Colors.grey.shade300,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: branchList.length,
                      itemBuilder: (context, index) {
                        final item = branchList[index];
                        return ListTile(
                          title: Text(item['name_branch'] ?? 'Kosong'),
                          onTap: () {
                            setState(() {
                              selectedBranch = item['id_branch'];
                            });
                            Navigator.pop(context);
                            widget.updateBranch(selectedBranch);
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
            decoration: InputDecoration(
              labelText: 'Cabang',
              hintText: 'Pilih cabang',
              labelStyle: TextStyle(color: Colors.black),
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: selectedBrand),
            readOnly: true,
            onTap: () {
              // Show the bottom sheet when the TextField is tapped
              showModalBottomSheet(
                backgroundColor: Colors.grey.shade300,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: brandList.length,
                      itemBuilder: (context, index) {
                        final item = brandList[index];
                        return ListTile(
                          title: Text(item['name_brand']),
                          onTap: () {
                            setState(() {
                              selectedBrand = item['name_brand'];
                            });
                            Navigator.pop(
                                context); // Close the BottomSheet after selection
                            widget.updateBrand(selectedBrand);
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
            decoration: InputDecoration(
              labelText: 'Tipe',
              hintText: 'Berdasarkan tipe',
              labelStyle: TextStyle(color: Colors.black),
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        ),
      ],
    );
  }
}
