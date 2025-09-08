import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/core/usecases/usecase.dart';
import 'package:wejha/features/home/domain/usecases/get_home_data.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;
  HomeBloc({required this.getHomeData}) : super(HomeInitial()) {
    on<LoadHomeRequested>((event, emit) async {
      emit(HomeLoading());
      final result = await getHomeData(NoParams());
      result.fold(
        (failure) => emit(HomeError(_mapFailureToMessage(failure))),
        (data) => emit(HomeLoaded(data)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
} 