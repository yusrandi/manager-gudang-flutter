import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gudang_manager/bloc/auth_bloc/authentication_bloc.dart';
import 'package:gudang_manager/res/images.dart';
import 'package:gudang_manager/ui/screens/home_page.dart';
import 'package:gudang_manager/ui/screens/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthenticationBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<AuthenticationBloc>(context);
    _bloc.add(CheckLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, state) {
        print(state);
        loginAction(state);
      },
      child: Scaffold(
        body: Container(
          child: Center(
            child: Image.asset(Images.logoImage, height: 150),
          ),
        ),
      ),
    );
  }

  void loginAction(AuthenticationState state) async {
    //replace the below line of code with your login request
    await new Future.delayed(const Duration(seconds: 2));

    if (state is AuthLoggedOutState) {
      gotoAnotherPage(SignInScreen(
        authenticationBloc: _bloc,
      ));
    } else if (state is AuthLoggedInState) {
      gotoAnotherPage(LandingHomePage(
        authenticationBloc: _bloc,
        id: state.id,
      ));
    }
  }

  void gotoAnotherPage(Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
