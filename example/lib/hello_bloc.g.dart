// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hello_bloc.dart';

// **************************************************************************
// BlocCodegenGenerator
// **************************************************************************

extension BlocCodeGen on HelloBloc {
  setCounter(int i) => _counter.sink.add(i);
  Stream<int> get counter => _counter.stream;

  setWithInputOnly(String i) => _withInputOnly.sink.add(i);

  Stream<String> get withOutputOnly => _withOutputOnly.stream;
}
