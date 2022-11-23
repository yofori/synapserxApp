import 'package:flutter/material.dart';

class RxButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  //final Function onTap;
  const RxButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return InkWell(
        splashColor: const Color(0xFF3B4257),
        //onTap: widget.onSelect,
        onTap: onTap,
        child: Card(
            child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon),
                Text(
                  title,
                  textAlign: TextAlign.center,
                )
              ]),
        )),
      );
    });
  }
}
