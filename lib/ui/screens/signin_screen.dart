import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gudang_manager/bloc/auth_bloc/authentication_bloc.dart';
import 'package:gudang_manager/config/shared_info.dart';
import 'package:gudang_manager/constant/constant.dart';
import 'package:gudang_manager/res/images.dart';
import 'package:gudang_manager/res/strings.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/home_page.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool keyboardVisibility = false;

  final _userEmail = new TextEditingController();
  final _userPass = new TextEditingController();

  late AuthenticationBloc _authenticationBloc;
  late SharedInfo _sharedInfo;

  @override
  void initState() {
    super.initState();

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authenticationBloc.add(CheckLoginEvent());
    _sharedInfo = SharedInfo();

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      keyboardVisibility = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        print("State $state");
        if (state is AuthGetFailureState) {
          print("State ${state.error}");
          _alertError(state.error);
        } else if (state is AuthGetSuccess) {
          print("State ${state.user.responsecode}");
          // ignore: unrelated_type_equality_checks
          if (state.user.responsecode == "1") {
            _alertSuccess("Berhasil");
            _sharedInfo.sharedLoginInfo(state.user.user);
            gotoHomePage();
          } else {
            _alertError("Maaf Anda Belum Terdaftar");
          }
        } else if (state is AuthLoadingState)
          _alertLoading();
        else if (state is AuthLoggedInState) gotoHomePage();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Center(
            child: _homeContainer(),
          ),
        ),
      ),
    );
  }

  Widget _homeContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      color: AppTheme.appBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Image.asset(
                Images.logoImage,
                height: 100,
              ),
            ),
          ),
          Text(
            Strings.getStartedButton,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Container(
            child: Text(
              Strings.welcomeScreenTitle,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Enter Email",
            icon: Icons.email,
            controller: _userEmail,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Enter Password",
            icon: Icons.lock,
            controller: _userPass,
          ),
          SizedBox(height: 16),
          GestureDetector(
              onTap: () {
                String email = _userEmail.text.trim();
                String pass = _userPass.text.trim();

                if (email.isNotEmpty && pass.isNotEmpty) {
                  _authenticationBloc
                      .add(LoginEvent(email: email, password: pass));
                } else {
                  _alertError("Harap Mengisi Semua Kolom");
                }
                // gotoHomePage();
              },
              child: PrimaryButton(btnText: "Sign In")),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _alertLoading() {
    CircularProgressIndicator();
  }

  void _alertSuccess(String msg) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs:
            ArtDialogArgs(type: ArtSweetAlertType.success, title: msg));
  }

  void _alertError(String msg) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger, title: "Oops...", text: msg));
  }

  void gotoHomePage() {
    Navigator.of(context).pushReplacement(//new
        new MaterialPageRoute(
            //new
            settings: const RouteSettings(name: '/form'), //new
            builder: (context) => new HomePage()) //new
        //new
        );
  }
}

class PrimaryButton extends StatefulWidget {
  final String btnText;
  const PrimaryButton({required this.btnText});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.redBackgroundColor,
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(widget.btnText,
            style: Theme.of(context).primaryTextTheme.headline6),
      ),
    );
  }
}

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

class InputWithIcon extends StatefulWidget {
  final String inputText;
  final IconData icon;
  final TextEditingController controller;

  const InputWithIcon(
      {key,
      required this.inputText,
      required this.icon,
      required this.controller})
      : super(key: key);

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.hintTextColor, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Icon(
              widget.icon,
              size: 20,
              color: AppTheme.hintTextColor,
            ),
          ),
          Expanded(
              child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                hintText: widget.inputText),
          ))
        ],
      ),
    );
  }
}
