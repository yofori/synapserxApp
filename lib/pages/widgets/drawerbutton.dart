import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/service.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalData.defaultAccount.isEmpty
        ? Badge(
            badgeContent: const Text(''),
            position: BadgePosition.topEnd(top: 5, end: 15),
            child: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu)))
        : IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu));
  }
}
