import 'package:flutter/material.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

class ModifierInput extends StatefulWidget {
  final String label;
  final Function updateValue;
  final String placeHolder;
  const ModifierInput({super.key, required this.label, required this.updateValue, required this.placeHolder});

  @override
  State<ModifierInput> createState() => _ModifierInputState();
}

class _ModifierInputState extends State<ModifierInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Etichetta
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(widget.label, style: blackText14w700),
        ),
        const SizedBox(height: 6),

        /// Campo di input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: primaryBlue),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: widget.placeHolder,
                    border: InputBorder.none,
                  ),
                  style: blueText14w700,
                  onChanged: (value) =>  widget.updateValue(value),
                  validator: (value) =>
                  (value == null || value.isEmpty) ? 'Inserisci un valore' : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
