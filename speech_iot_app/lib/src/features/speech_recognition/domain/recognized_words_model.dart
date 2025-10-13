import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class RecognizedWordsModel extends Equatable {
  final String words;
  final double confidence;

  const RecognizedWordsModel({required this.words, required this.confidence});

  @override
  List<Object?> get props => [words, confidence];
}
