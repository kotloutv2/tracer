import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VitalsCard extends StatelessWidget {
  final String location;
  final String title;
  final Icon icon;
  final String value;

  const VitalsCard(
      {Key? key,
      required this.title,
      required this.location,
      required this.icon,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(location);
      },
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        icon,
        Text(value),
      ]),
    );
  }
}
