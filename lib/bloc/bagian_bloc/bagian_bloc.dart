import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/models/bagian.dart';
import 'package:gudang_manager/repo/bagian_repository.dart';

class BagianBloc extends Bloc<BagianEvent, BagianState> {
  BagianRepository repository;
  BagianBloc(this.repository) : super(BagianInitialState());

  @override
  Stream<BagianState> mapEventToState(BagianEvent event) async*{
    if (event is FetchBagianEvent) {
      yield* mapFetchBagianEventToState(event);
    } 
  }

  Stream<BagianState> mapFetchBagianEventToState(
      BagianEvent event) async* {
    yield BagianLoadingState();
    if (event is FetchBagianEvent) {
      try {
        var bagians = await repository.getBagian();
        if (bagians.responsecode == "1") {
          yield BagianLoadedState(bagians.bagian);
        } else {
          yield BagianErrorState(bagians.responsemsg);
        }
      } catch (e) {
        yield BagianErrorState(e.toString());
      }
    } else {}
  }
}

//Laporan Event
abstract class BagianEvent extends Equatable {}

class FetchBagianEvent extends BagianEvent {
  FetchBagianEvent();
  @override
  List<Object> get props => [];
}

//Laporan State
abstract class BagianState extends Equatable {}

class BagianInitialState extends BagianState {
  @override
  List<Object> get props => [];
}

class BagianLoadingState extends BagianState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class BagianLoadedState extends BagianState {
  List<Bagian> bagians;
  BagianLoadedState(this.bagians);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class BagianSuccessState extends BagianState {
  String msg;
  BagianSuccessState(this.msg);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class BagianErrorState extends BagianState {
  String msg;
  BagianErrorState(this.msg);

  @override
  List<Object> get props => [];
}
