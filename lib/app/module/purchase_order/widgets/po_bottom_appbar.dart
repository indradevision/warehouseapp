import 'package:flutter/material.dart';

class PoBottomAppbar extends StatefulWidget {
  final bool isElevated;
  final bool isVisible;
  final String toDateValue;
  final String fromDateValue;
  final Function(String) onFromDateChanged; // Callback for From date
  final Function(String) onToDateChanged; // Callback for To date

  const PoBottomAppbar({
    Key? key,
    required this.isElevated,
    required this.isVisible,
    required this.toDateValue,
    required this.fromDateValue,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  }) : super(key: key);

  @override
  _PoBottomAppbarState createState() => _PoBottomAppbarState();
}

class _PoBottomAppbarState extends State<PoBottomAppbar> {
  TextEditingController _dateFromController = TextEditingController();
  TextEditingController _dateToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateFromController = TextEditingController(text: widget.fromDateValue);
    _dateToController = TextEditingController(text: widget.toDateValue);
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, Function(String) onDateChanged) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {
        controller.text = formattedDate;
      });
      onDateChanged(formattedDate); // Notify the parent about the date change
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.isVisible ? 80.0 : 0,
      child: Visibility(
        visible: widget.isVisible,
        child: IgnorePointer(
          ignoring: !widget.isVisible,
          child: BottomAppBar(
            color: Colors.white,
            shadowColor: Colors.black,
            elevation: widget.isElevated ? null : 0.0,
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _dateFromController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Dari",
                      hintText: 'Dari tanggal',
                    ),
                    onTap: () => _selectDate(
                        context, _dateFromController, widget.onFromDateChanged),
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _dateToController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Sampai",
                      hintText: 'Sampai tanggal',
                    ),
                    onTap: () => _selectDate(
                        context, _dateToController, widget.onToDateChanged),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
