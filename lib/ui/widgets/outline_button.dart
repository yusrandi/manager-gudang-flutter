import 'package:flutter/material.dart';
import 'package:gudang_manager/res/styling.dart';

class OutLineBtn extends StatefulWidget {
  final String btnText;

  const OutLineBtn({key, required this.btnText}) : super(key: key);

  @override
  _OutLineBtnState createState() => _OutLineBtnState();
}

class _OutLineBtnState extends State<OutLineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border.all(color: AppTheme.selectedTabBackgroundColor, width: 2),
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(15),
      child: Center(
        child:
            Text(widget.btnText, style: Theme.of(context).textTheme.headline6),
      ),
    );
  }
}