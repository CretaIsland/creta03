import 'package:flutter/material.dart';

class DropDownRow extends StatelessWidget {
  final String label;
  final String value;
  final Map currencies;
  final void Function(String?) onChanged;
  const DropDownRow({
    super.key,
    required this.label,
    required this.value,
    required this.currencies,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      child: DropdownButtonFormField<String>(
        menuMaxHeight: 320.0,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        value: value,
        icon: const Icon(Icons.arrow_drop_down_rounded),
        isExpanded: true,
        onChanged: onChanged,
        items: currencies.keys.toSet().toList().map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              '$value',
              // '$value - ${currencies[value]}',
              // '${currencies[value]}',
              // overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }
}
