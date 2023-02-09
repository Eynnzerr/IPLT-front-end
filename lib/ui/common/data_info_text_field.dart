import 'package:flutter/material.dart';

class DataInfoTextField extends StatelessWidget {
  const DataInfoTextField({
    Key? key,
    required this.title,
    required this.defaultText,
    required this.isEnabled,
    required this.onChanged
  }) : super(key: key);
  final String title;
  final String defaultText;
  final bool isEnabled;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 8),
            child: Text(title),
          ),
          Expanded(
              child: TextFormField(
                initialValue: defaultText,
                enabled: isEnabled,
                decoration: const InputDecoration.collapsed(hintText: ''),
                onChanged: onChanged,
              )
          )
        ],
      ),
    );
  }
}
