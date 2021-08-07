
class SliderModel {
  String title;
  int background;
  int botbackground;
  int topbackground;

  SliderModel(
      this.title, this.background,  this.botbackground, this.topbackground);
}

List<SliderModel> sliders = [

  SliderModel("Penerimaan", 0xffFF8554, 0xffad3100, 0xffad3100),
  SliderModel("Pengeluaran", 0xffad3100, 0xffFF8554, 0xffFF8554 ),
  SliderModel("Rekapitulasi", 0xffFF8554, 0xffad3100, 0xffad3100),

];

