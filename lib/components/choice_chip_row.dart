import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiceChipRow extends StatefulWidget {

  final List<String> choices;
  final Function changeSelected;  
  final int initialSelected;

  const ChoiceChipRow({
    super.key,
    required this.choices,
    required this.changeSelected,
    required this.initialSelected,
  });

  @override
  _ChoiceChipRowState createState() => _ChoiceChipRowState();
}

class _ChoiceChipRowState extends State<ChoiceChipRow> {
  int _selectedChoice= 0;

  @override
  void initState() {
    super.initState();
    _selectedChoice = widget.initialSelected;
  }  

  @override
  Widget build(BuildContext context) {
    List<String> choices = widget.choices;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: choices.map((choice) {
        int index = choices.indexOf(choice);
        return ChoiceChip(
          label: Container(
            width: Get.mediaQuery.size.width*0.24,
            child: Text(choice, textAlign: TextAlign.center),
          ),
          selected: _selectedChoice == index,
          selectedColor: Get.theme.primaryColor,            
          labelStyle: Get.textTheme.bodyMedium!.copyWith(
            color: _selectedChoice == index ? Colors.white : Colors.black,
          ),          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onSelected: (bool selected) {
            setState(() {
              _selectedChoice = selected ? index : 0;
              widget.changeSelected(_selectedChoice);
            });
          },
        );
      }).toList(),
    );
  }
}