import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gudang_manager/bloc/auth_bloc/authentication_bloc.dart';
import 'package:gudang_manager/constant/constant.dart';
import 'package:gudang_manager/helper/keyboard.dart';
import 'package:gudang_manager/models/user_models.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/widgets/primary_button.dart';

class SettingScreen extends StatefulWidget {
  final int id;
  final AuthenticationBloc authenticationBloc;

  const SettingScreen(
      {Key? key, required this.id, required this.authenticationBloc})
      : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _userName = new TextEditingController();
  final _userPass = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? validateName(value) {
    if (value.isEmpty) {
      return "Please Enter Your Name";
    } else {
      return null;
    }
  }

  String? validatePass(value) {
    if (value.isEmpty) {
      return null;
    } else if (value.length < 8) {
      return kShortPassError;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.authenticationBloc.add(GetUserEvent(id: widget.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.redBackgroundColor,
        elevation: 0,
        title: Text('Setting'),
        centerTitle: false,
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, state) {
        print(state);
        if (state is AuthLoadingState || state is AuthenticationInitialState)
          EasyLoading.show();
        else if (state is AuthGetFailureState) {
          print("State ${state.error}");
          EasyLoading.dismiss();
          EasyLoading.showError(state.error);
        }
      }, child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (BuildContext context, state) {
        if (state is AuthGetSuccess) {
          EasyLoading.dismiss();
          return _buildUser(state.user.user);
        } else {
          return _buildLoading();
        }
      })),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Text("Please Wait . . ."),
    );
  }

  Column _buildUser(User user) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email Anda",
                      style: TextStyle(color: hintTextColor),
                    ),
                    containerField(user.email),
                    SizedBox(height: 16),
                    Text(
                      "Nama Anda",
                      style: TextStyle(color: hintTextColor),
                    ),
                    TextFormField(
                        controller: _userName,
                        validator: validateName,
                        cursorColor: redColor,
                        decoration:
                            inputDecorationField(user.name, Icons.person)),
                    SizedBox(height: 16),
                    Text(
                      "New Password ?",
                      style: TextStyle(color: hintTextColor),
                    ),
                    TextFormField(
                        validator: validatePass,
                        controller: _userPass,
                        cursorColor: redColor,
                        decoration: inputDecorationField(
                            "New Password ?", Icons.lock_rounded)),
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              String name = _userName.text.trim();
              String pass = _userPass.text.trim();

              var password = pass.isEmpty ? "null" : pass;
              widget.authenticationBloc.add(UserUpdateEvent(
                  id: user.id.toString(), name: name, password: password));

              _userName.text = "";
              _userPass.text = "";
            }

            KeyboardUtil.hideKeyboard(context);
          },
          child: Container(
              margin: EdgeInsets.all(8),
              child: PrimaryButton(btnText: "Submit", color: Colors.redAccent)),
        )
      ],
    );
  }

  InputDecoration inputDecorationField(String hint, IconData icon) {
    return InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
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
        ));
  }

  Container containerField(String email) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: hintTextColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.email,
            color: hintTextColor,
            size: 26,
          ),
          SizedBox(width: 16),
          Expanded(
              child: Text(
            '$email',
            style: TextStyle(fontSize: 16),
          )),
        ],
      ),
    );
  }
}
