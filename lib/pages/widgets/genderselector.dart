import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/pages/widgets/customradio.dart';

class GenderSelector extends StatefulWidget {
  final Function(String) onSelect;
  final List genders;
  const GenderSelector(
      {super.key, required this.onSelect, required this.genders});

  @override
  GenderSelectorState createState() => GenderSelectorState();
}

class GenderSelectorState extends State<GenderSelector> {
  //List<Gender> genders = <Gender>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: widget.genders.length,
          itemBuilder: (context, index) {
            return InkWell(
              splashColor: const Color(0xFF3B4257),
              //onTap: widget.onSelect,
              onTap: () {
                setState(() {
                  for (var gender in widget.genders) {
                    gender.isSelected = false;
                  }
                  widget.genders[index].isSelected = true;
                  widget.onSelect(widget.genders[index].name);
                });
              },
              child: CustomRadio(widget.genders[index]),
            );
          }),
    );
  }
}
