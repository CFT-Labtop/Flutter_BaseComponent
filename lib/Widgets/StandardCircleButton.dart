import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';

class StandardCircleButton extends StatelessWidget {
  final void Function() onPress;
  final IconData icon;
  final Color color;
  final Color splashColor;
  const StandardCircleButton({
    required Key? key,
    required this.onPress,
    required this.icon,
    required this.color,
    required this.splashColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Icon(icon, color: Colors.white),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
        primary: color, // <-- Button color
        onPrimary: splashColor, // <-- Splash color
      ),
    );
  }
}
