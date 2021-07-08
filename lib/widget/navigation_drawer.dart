import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gudang_manager/res/images.dart';
import 'package:gudang_manager/res/styling.dart';

class NavigationDrawer extends StatelessWidget {

  final padding = EdgeInsets.all(20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: AppTheme.selectedTabBackgroundColor,
        child: ListView(
          padding: padding,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Image.asset(Images.homeImage),
              ),
            ),
            const SizedBox(height: 5),
            buildMenuItem(text: 'Data Penerimaan', icon: Icons.inbox, context: context),
            buildMenuItem(text: 'Data Pengeluaran', icon: Icons.drive_file_move, context: context),
            Divider(color: Colors.white,)
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required String text, required IconData icon, required BuildContext context}) {

    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color,) ,
      title: Text(text, style: Theme.of(context).primaryTextTheme.headline5),
      hoverColor: hoverColor,
      onTap: (){},
    );
  }


}
