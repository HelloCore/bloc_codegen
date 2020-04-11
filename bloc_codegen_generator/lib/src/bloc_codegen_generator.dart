import 'dart:collection';

import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:bloc_codegen/bloc_codegen.dart';


class BlocCodegenGenerator extends GeneratorForAnnotation<Bloc> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Remove the [Bloc] annotation from `$name`.',
      );
    }
    return _implementClass(element, annotation);
  }

  String _normalizeDisplayName(String displayName) {
    if(displayName.startsWith("_")) {
      return displayName.substring(1);
    }
    return displayName;
  }

  DartType _argTypeOf(DartType type) {
    return type is ParameterizedType && type.typeArguments.isNotEmpty ? type.typeArguments.first: null;
  }

  String _inputForField(FieldElement fieldElement) {
    final blocInputAnnoType = TypeChecker.fromRuntime(BlocInput);
    final annotInput = blocInputAnnoType.firstAnnotationOf(fieldElement, throwOnUnresolved: false);
    if(annotInput != null) {
      final argType = _argTypeOf(fieldElement.type);
      if(argType == null) {
        throw InvalidGenerationSourceError(
          'Generator cannot find type of `${fieldElement.name}`.',
          todo: 'Please change type of `${fieldElement.name}`.',
        );
      }
      var rawDisplayName = ConstantReader(annotInput)?.peek("inputName")?.stringValue;
      if(rawDisplayName == null || rawDisplayName.isEmpty) {
        rawDisplayName = _normalizeDisplayName(fieldElement.displayName);
      }
      final displayName = rawDisplayName.substring(0,1).toUpperCase() + rawDisplayName.substring(1);
      return "  set${displayName}(${argType.getDisplayString()} i) => ${fieldElement.name}.sink.add(i);";
    }
    return null;
  } 

  String _outputForField(FieldElement fieldElement) {
    final blocOutputAnnoType = TypeChecker.fromRuntime(BlocOutput);
    final annoOutput = blocOutputAnnoType.firstAnnotationOf(fieldElement, throwOnUnresolved: false);
    if(annoOutput != null) {
      final argType = _argTypeOf(fieldElement.type);
      if(argType == null) {
        throw InvalidGenerationSourceError(
          'Generator cannot find type of `${fieldElement.name}`.',
          todo: 'Please change type of `${fieldElement.name}`.',
        );
      }
      var displayName = ConstantReader(annoOutput)?.peek("outputName")?.stringValue;
      if(displayName == null || displayName.isEmpty) {
        displayName = _normalizeDisplayName(fieldElement.displayName);
      }
      return "  Stream<${argType.getDisplayString()}> get ${displayName} => ${fieldElement.name}.stream;";
    }
    return null;
    
  } 

  String _implementClass(ClassElement element, ConstantReader annotation) {
    var result = ListQueue<String>();
    result.add("extension BlocCodeGen on ${element.displayName} {");
    element.fields.forEach((field) {
      if(!field.isPrivate) {

        throw InvalidGenerationSourceError(
          'Field `${field.displayName}` of class `${element.displayName}` is not private.',
          todo: 'Please change `${field.displayName}` of of class `${element.displayName}` to private.',
        );
      }

      final inputStr = _inputForField(field);
      if(inputStr != null) {
        result.add(inputStr);
      }

      final outputStr = _outputForField(field);
      if(outputStr != null) {
        result.add(outputStr);
      }

      result.add("");
    });
    result.add("}");
    return result.join("\n");
  }
  
}