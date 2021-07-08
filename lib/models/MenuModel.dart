import 'package:flutter/material.dart';
import 'package:gudang_manager/constant/constant.dart';
import 'package:gudang_manager/res/images.dart';

class MenuModel {
  String title;
  String icon;

  MenuModel(
      this.title, this.icon);
}

List<MenuModel> menus = [

  MenuModel("Penerimaan", Images.ic_penerimaan ),
  MenuModel("Penegluaran", Images.ic_pengeluaran ),
  MenuModel("Laporan", Images.ic_penerimaan ),
  MenuModel("Rekapitulasi", Images.ic_rekapitulasi ),

];

