class Bloc {
  const Bloc();
}

class BlocInput {
  final String inputName;

  const BlocInput({this.inputName = ""}) : assert(inputName != null);
}

class BlocOutput {
  final String outputName;

  const BlocOutput({this.outputName = ""}) : assert(outputName != null);
}