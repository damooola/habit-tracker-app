import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final Icon icon;
  final void Function()? onTap;
  const DrawerListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: Text(title),
        leading: icon,
        onTap: onTap,
      ),
    );
  }
}
