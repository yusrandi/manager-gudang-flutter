import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gudang_manager/bloc/auth_bloc/authentication_bloc.dart';
import 'package:gudang_manager/models/SliderModel.dart';
import 'package:gudang_manager/res/images.dart';
import 'package:gudang_manager/res/strings.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/pb22_page.dart';
import 'package:gudang_manager/ui/screens/pb23_page.dart';
import 'package:gudang_manager/ui/screens/penerimaan_page.dart';
import 'package:gudang_manager/ui/screens/pengeluaran_page.dart';
import 'package:gudang_manager/ui/screens/rekapitulasi_page.dart';
import 'package:gudang_manager/ui/screens/setting_page.dart';
import 'package:gudang_manager/ui/screens/signin_screen.dart';

class LandingHomePage extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;
  final int id;

  const LandingHomePage(
      {Key? key, required this.authenticationBloc, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HomePage(authenticationBloc: authenticationBloc, id: id),
    );
  }
}

class HomePage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final int id;

  const HomePage({Key? key, required this.authenticationBloc, required this.id})
      : super(key: key);

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
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, state) {
        print(state);
        if (state is AuthLoggedOutState) {
          gotoSignInPage(
              SignInScreen(authenticationBloc: widget.authenticationBloc));
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.redBackgroundColor,
            elevation: 0,
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.getStartedButton,
                    style: Theme.of(context).primaryTextTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  PopupMenuButton<String>(
                    onSelected: handleClick,
                    color: Colors.white,
                    itemBuilder: (BuildContext context) {
                      return {'Logout', 'Settings'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ),
          body: _homeBody()),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Good Morning',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                        Text(
                          'Manager',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    Image.asset(Images.logoImage, height: 50),
                  ],
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
                      '${sliders[index].title} ${DateTime.now().year}',
                      style: Theme.of(context).primaryTextTheme.headline6,
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
                        Image.asset(Images.ic_b22, height: 35),
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
                        Image.asset(Images.ic_b23, height: 35),
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
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      gotoAnotherPage(RekapitulasiLandingPage());
                    },
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
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      gotoAnotherPage(RekapitulasiLandingPage());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Images.ic_penerimaan, height: 35),
                        Text(
                          'Pemeliharaan',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  )),
              Expanded(flex: 1, child: Container()),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        widget.authenticationBloc.add(LogOutEvent());
        break;
      case 'Settings':
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SettingScreen(
              id: widget.id, authenticationBloc: widget.authenticationBloc);
        }));
        break;
    }
  }

  void gotoAnotherPage(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  void gotoSignInPage(Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
