import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/models/pb22_model.dart';
import 'package:gudang_manager/models/pb23_model.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/models/pengeluaran.dart';
import 'package:gudang_manager/models/rekapitulasi_model.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';

class LaporanBloc extends Bloc<LaporanEvent, LaporanState> {
  LaporanRepository repository;
  LaporanBloc(this.repository) : super(LaporanInitialState());

  @override
  Stream<LaporanState> mapEventToState(LaporanEvent event) async* {
    if (event is FetchLaporanPenerimaanEvent) {
        yield LaporanLoadingState();
      try {
        var penerimaans = await repository.getPenerimaan(
            event.spesifikasiId, event.semester, event.tahun);
        yield LaporanLoadedState(penerimaans.penerimaan);
      } catch (e) {
        yield LaporanErrorState(e.toString());
      }
    } else if (event is FetchLaporanPengeluaranEvent) {
        yield LaporanLoadingState();
      try {
        var pengeluarans = await repository.getPengeluaran(
            event.spesifikasiId, event.bagianId, event.semester, event.tahun);
        
        yield LaporanLoadedStatePengeluaran(pengeluarans.pengeluaran);
      } catch (e) {
        yield LaporanErrorState(e.toString());
      }
    }else if (event is FetchLaporanEventPb22) {
        yield LaporanLoadingState();
      try {
        var data = await repository.getPb22(
            event.spesifikasiId, event.tahun);
        yield LaporanLoadedStatePb22(data.pb22);
      } catch (e) {
        yield LaporanErrorState(e.toString());
      }
    }else if (event is FetchLaporanEventPb23) {
        yield LaporanLoadingState();
      try {
        var data = await repository.getPb23(
            event.spesifikasiId, event.tahun);
        yield LaporanLoadedStatePb23(data.pb23);
      } catch (e) {
        yield LaporanErrorState(e.toString());
      }
    }else if (event is FetchLaporanEventRekapitulasi) {
        yield LaporanLoadingState();
      try {
        var data = await repository.getRekapitulasi(
            event.spesifikasiId, event.tahun);
        yield LaporanLoadedStateRekapitulasi(data.rekapitulasi);
      } catch (e) {
        yield LaporanErrorState(e.toString());
      }
    }
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

class FetchLaporanPengeluaranEvent extends LaporanEvent {
  final String spesifikasiId;
  final String bagianId;
  final String semester;
  final String tahun;
  FetchLaporanPengeluaranEvent(
      {required this.spesifikasiId,
      required this.bagianId,
      required this.semester,
      required this.tahun});
  @override
  List<Object> get props => [];
}

class FetchLaporanEventPb22 extends LaporanEvent {
  final String spesifikasiId;
  final String tahun;
  FetchLaporanEventPb22(
      {required this.spesifikasiId,
      required this.tahun});
  @override
  List<Object> get props => [];
}

class FetchLaporanEventPb23 extends LaporanEvent {
  final String spesifikasiId;
  final String tahun;
  FetchLaporanEventPb23(
      {required this.spesifikasiId,
      required this.tahun});
  @override
  List<Object> get props => [];
}
class FetchLaporanEventRekapitulasi extends LaporanEvent {
  final String spesifikasiId;
  final String tahun;
  FetchLaporanEventRekapitulasi(
      {required this.spesifikasiId,
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

class LaporanLoadedStatePengeluaran extends LaporanState {
  final List<Pengeluaran> laporans;
  LaporanLoadedStatePengeluaran(this.laporans);

  @override
  List<Object> get props => [];
}

class LaporanLoadedStatePb22 extends LaporanState {
  final List<Pb22> laporans;
  LaporanLoadedStatePb22(this.laporans);

  @override
  List<Object> get props => [];
}
class LaporanLoadedStatePb23 extends LaporanState {
  final List<Pb23> laporans;
  LaporanLoadedStatePb23(this.laporans);

  @override
  List<Object> get props => [];
}
class LaporanLoadedStateRekapitulasi extends LaporanState {
  final List<Rekapitulasi> laporans;
  LaporanLoadedStateRekapitulasi(this.laporans);

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
