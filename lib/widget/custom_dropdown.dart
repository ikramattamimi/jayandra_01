import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.list,
  });
  final List list;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  List items = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    items = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                'Pilih Bulan',
                style: Styles.buttonTextBlue,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: Styles.bodyTextBlack2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 30,
          width: 100,
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Styles.accentColor2,
            ),
            color: Styles.secondaryColor,
          ),
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          iconSize: 20,
          iconEnabledColor: Colors.grey,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 100,
          padding: null,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Styles.secondaryColor, border: Border.all(color: Styles.accentColor2)),
          elevation: 0,
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(5),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
