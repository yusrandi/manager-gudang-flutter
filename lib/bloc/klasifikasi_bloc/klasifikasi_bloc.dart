import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/repo/klasifikasi_repository.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';

class KlasifikasiBloc extends Bloc<KlasifikasiEvent, KlasifikasiState> {
  LaporanRepository repository;
  KlasifikasiBloc(this.repository) : super(KlasifikasiInitialState());

  @override
  Stream<KlasifikasiState> mapEventToState(KlasifikasiEvent event) async*{
    if (event is FetchKlasifikasiEvent) {
      yield* mapFetchKlasifikasiEventToState(event);
    } 
  }

  Stream<KlasifikasiState> mapFetchKlasifikasiEventToState(
      KlasifikasiEvent event) async* {
    yield KLasifikasiLoadingState();
    if (event is FetchKlasifikasiEvent) {
      try {
        var klasifikasis = await repository.getKlasifikasi();
        yield KlasifikasiLoadedState(klasifikasis.klasifikasi);
      } catch (e) {
        yield KlasifikasiErrorState(e.toString());
      }
    } else {}
  }
}

//Laporan Event
abstract class KlasifikasiEvent extends Equatable {}

class FetchKlasifikasiEvent extends KlasifikasiEvent {
  FetchKlasifikasiEvent();
  @override
  List<Object> get props => [];
}

//Laporan State
abstract class KlasifikasiState extends Equatable {}

class KlasifikasiInitialState extends KlasifikasiState {
  @override
  List<Object> get props => [];
}

class KLasifikasiLoadingState extends KlasifikasiState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class KlasifikasiLoadedState extends KlasifikasiState {
  List<Klasifikasi> klasifikasis;
  KlasifikasiLoadedState(this.klasifikasis);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class KlasifikasiSuccessState extends KlasifikasiState {
  String msg;
  KlasifikasiSuccessState(this.msg);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class KlasifikasiErrorState extends KlasifikasiState {
  String msg;
  KlasifikasiErrorState(this.msg);

  @override
  List<Object> get props => [];
}
