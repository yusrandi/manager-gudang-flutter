import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gudang_manager/bloc/auth_bloc/authentication_bloc.dart';
import 'package:gudang_manager/config/shared_info.dart';
import 'package:gudang_manager/constant/constant.dart';
import 'package:gudang_manager/helper/keyboard.dart';
import 'package:gudang_manager/res/images.dart';
import 'package:gudang_manager/res/strings.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/home_page.dart';

class SignInScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const SignInScreen({Key? key, required this.authenticationBloc})
      : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool keyboardVisibility = false;

  final _userEmail = new TextEditingController();
  final _userPass = new TextEditingController();

  late SharedInfo _sharedInfo;

  @override
  void initState() {
    super.initState();
    _sharedInfo = SharedInfo();
  }

  String? validateEmail(value) {
    if (value.isEmpty) {
      return kEmailNullError;
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      return kInvalidEmailError;
    } else {
      return null;
    }
  }

  String? validatePass(value) {
    if (value.isEmpty) {
      return kPassNullError;
    } else if (value.length < 8) {
      return kShortPassError;
    } else {
      return null;
    }
  }

  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        print("State $state");
        if (state is AuthGetFailureState) {
          print("State ${state.error}");
          EasyLoading.dismiss();
          EasyLoading.showError(state.error);
        } else if (state is AuthGetSuccess) {
          print("State ${state.user.responsecode}");
          // ignore: unrelated_type_equality_checks
          if (state.user.responsecode == "1") {
            EasyLoading.showSuccess("Welcome");
            _sharedInfo.sharedLoginInfo(state.user.user);
            gotoHomePage(state.user.user.id);
          } else {
            EasyLoading.dismiss();
            EasyLoading.showError(state.user.responsemsg);
          }
        } else if (state is AuthLoadingState ||
            state is AuthenticationInitialState) EasyLoading.show();
      },
      child: Scaffold(
        body: anotherHome(),
      ),
    );
  }

  Container anotherHome() {
    return Container(
      height: deviceHeight(context),
      padding: EdgeInsets.all(16),
      color: AppTheme.appBackgroundColor,
      child: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
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
                TextFormField(
                  cursorColor: redColor,
                  controller: _userEmail,
                  validator: validateEmail,
                  decoration:
                      buildInputDecoration(Icons.email, "Enter Your Email"),
                ),
                SizedBox(height: 16),
                passwordField(),
                SizedBox(height: 16),
                GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        String email = _userEmail.text.trim();
                        String pass = _userPass.text.trim();
                        widget.authenticationBloc
                            .add(LoginEvent(email: email, password: pass));
                      }

                      KeyboardUtil.hideKeyboard(context);
                      // gotoHomePage();
                    },
                    child: PrimaryButton(btnText: "Sign In")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      controller: _userPass,
      cursorColor: redColor,
      validator: validatePass,
      keyboardType: TextInputType.text,
      obscureText: !_passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.black),
        labelText: 'Password',
        hintText: 'Enter your password',
        // Here is key idea
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: redColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),

        prefixIcon: const Icon(Icons.lock),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.green, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: redColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: hintTextColor,
            width: 1,
          ),
        ),
      ),
    );
  }

  void gotoHomePage(int id) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LandingHomePage(
          authenticationBloc: widget.authenticationBloc, id: id);
    }));
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
          borderRadius: BorderRadius.circular(10)),
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
