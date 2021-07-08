// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/repo/user_repository.dart';
import 'package:gudang_manager/res/size_config.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/signin_screen.dart';

import 'bloc/auth_bloc/authentication_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Learning Platform Application',
              theme: AppTheme.lightTheme,
              home: BlocProvider(
                create: (context) => AuthenticationBloc(UserRepositoryImpl()),
                child: SignInScreen(),
              ),
            );
          },
        );
      },
    );
  }
}

