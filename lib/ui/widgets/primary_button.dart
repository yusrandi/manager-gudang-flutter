import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gudang_manager/res/styling.dart';

class PrimaryButton extends StatefulWidget {
  final String btnText;
  final Color color;
  const PrimaryButton({required this.btnText, required this.color});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all(8),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.print, color: Colors.white,),
            SizedBox(width: 8,),
            Text(widget.btnText,
              style: Theme.of(context).primaryTextTheme.subtitle1),
          ],
        ),
      ),
    );
  }
}
