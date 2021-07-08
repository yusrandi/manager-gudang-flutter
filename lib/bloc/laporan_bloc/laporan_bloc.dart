import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';

class LaporanBloc extends Bloc<LaporanEvent, LaporanState> {
  LaporanRepository repository;
  LaporanBloc(this.repository) : super(LaporanInitialState());

  @override
  Stream<LaporanState> mapEventToState(LaporanEvent event) async*{
    if (event is FetchLaporanPenerimaanEvent) {
      yield* mapFetchLaporanPenerimaanEventToState(event);
    } 
  }

  Stream<LaporanState> mapFetchLaporanPenerimaanEventToState(
      LaporanEvent event) async* {
    yield LaporanLoadingState();
    if (event is FetchLaporanPenerimaanEvent) {
      try {
        var penerimaans = await repository.getPenerimaan(
            event.spesifikasiId, event.semester, event.tahun);
        yield LaporanLoadedState(penerimaans.penerimaan);
      } catch (e) {
        yield LaporanErrorState(e.toString());
      }
    } else {}
  }
}

//Laporan Event
abstract class LaporanEvent extends Equatable {}

class FetchLaporanPenerimaanEvent extends LaporanEvent {
  final String spesifikasiId;
  final String semester;
  final String tahun;
  FetchLaporanPenerimaanEvent(
      {required this.spesifikasiId,
      required this.semester,
      required this.tahun});
  @override
  List<Object> get props => [];
}

//Laporan State
abstract class LaporanState extends Equatable {}

class LaporanInitialState extends LaporanState {
  @override
  List<Object> get props => [];
}

class LaporanLoadingState extends LaporanState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LaporanLoadedState extends LaporanState {
  List<Penerimaan> laporans;
  LaporanLoadedState(this.laporans);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LaporanSuccessState extends LaporanState {
  String msg;
  LaporanSuccessState(this.msg);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LaporanErrorState extends LaporanState {
  String msg;
  LaporanErrorState(this.msg);

  @override
  List<Object> get props => [];
}
