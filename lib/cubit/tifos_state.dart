part of 'tifos_cubit.dart';

abstract class TifosState {}

class TifosInProgress extends TifosState {}

class TifosLoadSuccess extends TifosState {
  final List<Tifo> tifos;
  TifosLoadSuccess({
    required this.tifos,
  });
}

class TifosLoadFailure extends TifosState {}
