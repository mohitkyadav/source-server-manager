import 'package:flutter/material.dart';
import 'package:turrant/themes/styling.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(this._icon, this._onPressed);

  final Icon _icon;
  final Function _onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppStyles.darkGray,
      ),
      child: IconButton(
        icon: _icon,
        onPressed: () {
          _onPressed();
        },
      ),
    );
  }
}
