import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomSynapseDropDown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset? offset;
  final String? Function(String?)? validator;

  const CustomSynapseDropDown({
    required this.hint,
    this.value,
    this.validator,
    required this.dropdownItems,
    this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      //To avoid long text overflowing.
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 14),
      ),
      value: value,
      validator: validator,
      items: dropdownItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Container(
                  alignment: valueAlignment,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      selectedItemBuilder: selectedItemBuilder,
      icon: icon ?? const Icon(Icons.arrow_drop_down),
      iconSize: iconSize ?? 30,
      iconEnabledColor: iconEnabledColor,
      iconDisabledColor: iconDisabledColor,
      buttonHeight: buttonHeight ?? 40,
      buttonWidth: buttonWidth ?? 140,
      buttonPadding:
          buttonPadding ?? const EdgeInsets.only(left: 20, right: 10),
      buttonDecoration: buttonDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.black45,
            ),
          ),
      buttonElevation: buttonElevation,
      itemHeight: itemHeight ?? 40,
      itemPadding: itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
      //Max height for the dropdown menu & becoming scrollable if there are more items. If you pass Null it will take max height possible for the items.
      dropdownMaxHeight: dropdownHeight ?? 200,
      dropdownWidth: dropdownWidth,
      dropdownPadding: dropdownPadding,
      dropdownDecoration: dropdownDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
      dropdownElevation: dropdownElevation ?? 8,
      scrollbarRadius: scrollbarRadius ?? const Radius.circular(40),
      scrollbarThickness: scrollbarThickness,
      scrollbarAlwaysShow: scrollbarAlwaysShow,
      //Null or Offset(0, 0) will open just under the button. You can edit as you want.
      offset: const Offset(0, 0),
      dropdownOverButton: false, //Default is false to show menu below button
    );
  }
}
