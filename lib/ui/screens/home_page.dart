import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gudang_manager/models/SliderModel.dart';
import 'package:gudang_manager/res/images.dart';
import 'package:gudang_manager/res/strings.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/penerimaan_page.dart';

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
              height: 150,
              width: 340,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(sliders[index].background)),
              child: Stack(
                children: [
                  Positioned(
                      top: -50,
                      left: -50,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(sliders[index].topbackground)),
                      )),
                  Positioned(
                      right: -50,
                      bottom: -50,
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(sliders[index].botbackground)),
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
              GestureDetector(
                onTap: () {
                  gotoAnotherPage(1);
                },
                child: Expanded(
                    flex: 1,
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
                    )),
              ),
              Expanded(
                  flex: 1,
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
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Images.ic_penerimaan, height: 35),
                      Text(
                        'Laporan',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Images.ic_rekapitulasi, height: 35),
                      Text(
                        'Rekapitulasi',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45),
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(height: 26),
          
        ],
      ),
    );
  }

  void gotoAnotherPage(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      if (index == 1) {
        return LandingPenerimaanPage();
      } else {
        return LandingHomePage();
      }
    }));
  }
}
