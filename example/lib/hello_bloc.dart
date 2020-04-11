import 'package:bloc_codegen/bloc_codegen.dart';
import 'package:rxdart/subjects.dart';

part 'hello_bloc.g.dart';

@Bloc()
class HelloBloc {

  @BlocInput()
  @BlocOutput()
  final BehaviorSubject<int> _counter = BehaviorSubject.seeded(0);

  @BlocInput()
  final PublishSubject<String> _withInputOnly = PublishSubject();

  @BlocOutput()
  final PublishSubject<String> _withOutputOnly = PublishSubject();

  close() {
    _counter.close();
    _withInputOnly.close();
    _withOutputOnly.close();

  }
}
