import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gudang_manager/models/SliderModel.dart';
import 'package:gudang_manager/res/images.dart';
import 'package:gudang_manager/res/strings.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/pb22_page.dart';
import 'package:gudang_manager/ui/screens/pb23_page.dart';
import 'package:gudang_manager/ui/screens/penerimaan_page.dart';
import 'package:gudang_manager/ui/screens/pengeluaran_page.dart';

class LandingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: AppTheme.redBackgroundColor,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.getStartedButton,
                style: Theme.of(context).primaryTextTheme.headline5,
                textAlign: TextAlign.center,
              ),
              Image.asset(Images.logoImage, height: 35),
            ],
          ),
        ),
      ),
      body: _homeBody(),
    );
  }

  Widget _homeBody() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45),
                ),
                Text(
                  'Manager Use',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 16),
                _homeSlider(),
                SizedBox(height: 16),
                _menuSlider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeSlider() {
    return Container(
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sliders.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 6),
              width: 300,
              child: Stack(
                children: [
                  Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.red[300]),
                      )),
                  Positioned(
                      bottom: 0,
                      left: 10,
                      right: 10,
                      child: Container(
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(colors: [
                              Colors.red,
                              Colors.blue,
                            ])),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Total",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            Text("Rp. 1.000.000",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30))
                          ],
                        )),
                      )),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Text(
                      sliders[index].title,
                      style: Theme.of(context).primaryTextTheme.headline5,
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _menuSlider() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      gotoAnotherPage(LandingPenerimaanPage());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Images.ic_penerimaan, height: 35),
                        Text(
                          'Penerimaan',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      gotoAnotherPage(PengeluaranLandingPage());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Images.ic_pengeluaran, height: 35),
                        Text(
                          'Pengeluaran',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      gotoAnotherPage(Pb22LandingPage());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Images.ic_penerimaan, height: 35),
                        Text(
                          'KPB B.22',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      gotoAnotherPage(Pb23LandingPage());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Images.ic_penerimaan, height: 35),
                        Text(
                          'KPB B.23',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  )),
              
            ],
          ),
          SizedBox(height: 26),
        ],
      ),
    );
  }

  void gotoAnotherPage(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
