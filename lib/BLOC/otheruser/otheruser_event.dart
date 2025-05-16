// ignore_for_file: camel_case_types, must_be_immutable

part of 'otheruser_bloc.dart';

sealed class OtheruserEvent extends Equatable {
  const OtheruserEvent();

  @override
  List<Object> get props => [];
}

class fetchUserinfo extends OtheruserEvent {
  String Userid;
  fetchUserinfo({required this.Userid});
}
