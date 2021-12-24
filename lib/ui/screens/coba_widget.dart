import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:gudang_manager/constant/constant.dart';

class CobaWidget extends StatefulWidget {
  const CobaWidget({Key? key}) : super(key: key);

  @override
  _CobaWidgetState createState() => _CobaWidgetState();
}

class _CobaWidgetState extends State<CobaWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
//          defaultColumnWidth:
//              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
        border: TableBorder.all(
            color: Colors.black26, width: 1, style: BorderStyle.none),
        children: [],
      ),
    );
  }
}
