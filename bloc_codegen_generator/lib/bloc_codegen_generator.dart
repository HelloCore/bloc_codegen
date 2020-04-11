import 'package:bloc_codegen_generator/src/bloc_codegen_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder blocCodegen(BuilderOptions options) =>
    SharedPartBuilder([BlocCodegenGenerator()], 'bloc_codegen');