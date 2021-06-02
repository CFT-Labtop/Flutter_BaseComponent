import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';


class StandardOutlinedButton extends StatelessWidget {
  final void Function()? onPress;
  final String text;
  final Color fontColor;
  final Color borderColor;
  const StandardOutlinedButton(
      {required Key key,
      this.onPress,
      required this.text,
      this.fontColor = Colors.white,
      this.borderColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(this.text, style: TextStyle(color: this.fontColor, fontSize: Util.responsiveSize(context, 24))),
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.only(top: Util.responsiveSize(context, 16), bottom: Util.responsiveSize(context, 16), left: Util.responsiveSize(context, 28), right: Util.responsiveSize(context, 28)),
          side: BorderSide(width: 2, color: Color(0xffffffff)),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0))),
      onPressed: this.onPress,
    );
  }
}
