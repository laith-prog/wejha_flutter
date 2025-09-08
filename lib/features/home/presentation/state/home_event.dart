import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHomeRequested extends HomeEvent {
  final bool force;
  LoadHomeRequested({this.force = false});

  @override
  List<Object?> get props => [force];
} 