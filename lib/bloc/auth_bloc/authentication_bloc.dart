import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gudang_manager/config/api.dart';
import 'package:gudang_manager/models/user_models.dart';
import 'package:gudang_manager/repo/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository repository;

  AuthenticationBloc(this.repository) : super(AuthenticationInitialState());
  AuthenticationState get initialState => AuthenticationInitialState();

  late SharedPreferences sharedpref;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is LoginEvent) {
      try {
        yield AuthLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.getLogin(event.email, event.password);
        yield AuthGetSuccess(user: data);
      } catch (e) {
        yield AuthGetFailureState(error: e.toString());
      }
    } else if (event is CheckLoginEvent) {
      sharedpref = await SharedPreferences.getInstance();
      var data = sharedpref.get("idUser");
      print("data $data");
      if (data != null)
        yield AuthLoggedInState(id: int.parse(data.toString()));
      else
        yield AuthLoggedOutState();
    } else if (event is LogOutEvent) {
      sharedpref = await SharedPreferences.getInstance();
      await sharedpref.clear();
      yield AuthLoggedOutState();
    } else if (event is GetUserEvent) {
      yield AuthLoadingState();
      await Future.delayed(const Duration(milliseconds: 30));
      final data = await repository.getUser(event.id);
      yield AuthGetSuccess(user: data);
    } else if (event is UserUpdateEvent) {
      try {
        yield AuthLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data =
            await repository.userUpdate(event.id, event.name, event.password);
        yield AuthGetSuccess(user: data);
      } catch (e) {
        yield AuthGetFailureState(error: e.toString());
      }
    }
  }
}
