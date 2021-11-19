import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/repo/barang_repository.dart';

class BarangBloc extends Bloc<BarangEvent, BarangState> {
  BarangRepository repository;
  BarangBloc(this.repository) : super(BarangInitialState());

  @override
  Stream<BarangState> mapEventToState(BarangEvent event) async* {
    if (event is FetchBarangEvent) {
      yield* mapFetchBarangEventToState(event);
    }
  }

  Stream<BarangState> mapFetchBarangEventToState(BarangEvent event) async* {
    yield BarangLoadingState();
    if (event is FetchBarangEvent) {
      try {
        var bagians = await repository.getBarang();
        if (bagians.responsecode == "1") {
          yield BarangLoadedState(bagians.barang);
        } else {
          yield BarangErrorState(bagians.responsemsg);
        }
      } catch (e) {
        yield BarangErrorState(e.toString());
      }
    }
  }
}

//Laporan Event
abstract class BarangEvent extends Equatable {}

class FetchBarangEvent extends BarangEvent {
  FetchBarangEvent();
  @override
  List<Object> get props => [];
}

//Laporan State
abstract class BarangState extends Equatable {}

class BarangInitialState extends BarangState {
  @override
  List<Object> get props => [];
}

class BarangLoadingState extends BarangState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class BarangLoadedState extends BarangState {
  List<Barang> barangs;
  BarangLoadedState(this.barangs);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class BarangSuccessState extends BarangState {
  String msg;
  BarangSuccessState(this.msg);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class BarangErrorState extends BarangState {
  String msg;
  BarangErrorState(this.msg);

  @override
  List<Object> get props => [];
}
