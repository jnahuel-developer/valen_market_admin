import 'package:flutter/material.dart';

class CustomSimpleInformation extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Key? fieldKey;

  const CustomSimpleInformation({
    super.key,
    required this.label,
    required this.controller,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 20),
          SizedBox(
            width: 100,
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 250,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              key: fieldKey,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
