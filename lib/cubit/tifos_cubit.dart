import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:tifos_test/models/tifo.dart';
import 'package:tifos_test/networking/api_base_helper.dart.dart';
part 'tifos_state.dart';

class TifosCubit extends Cubit<TifosState> {
  TifosCubit() : super(TifosInProgress()) {
    fetchTifos();
  }

  void fetchTifos() async {
    emit(TifosInProgress());
    try {
      String responce = await ApiBaseHelper().post(ApiBaseHelper.Suggest);

      List<Tifo> tifos = [];
      Map jsonMap = json.decode(responce);
      List rooms = jsonMap['rooms'];
      for (var i = 0; i < rooms.length; i++) {
        tifos.add(Tifo(
            name: rooms[i]['room_name'] ?? '',
            thumbnail: rooms[i]['thumbnail'] ??
                'https://pic.onlinewebfonts.com/svg/img_148071.png'));
      }
      log(tifos.length.toString());

      if (tifos.isEmpty) {
        emit(TifosLoadFailure());
        return;
      }
      emit(TifosLoadSuccess(tifos: tifos));
    } catch (_) {
      emit(TifosLoadFailure());
    }
  }
}
