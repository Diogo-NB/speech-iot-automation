class RecognizedSpeechResultDto {
  final List<(String words, double confidence)> words;

  const RecognizedSpeechResultDto(this.words);

  List<Map<String, dynamic>> toJson() =>
      words.map((word) => {'words': word.$1, 'confidence': word.$2}).toList();
}
